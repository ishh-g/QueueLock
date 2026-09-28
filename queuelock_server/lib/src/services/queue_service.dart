import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'ledger_service.dart';
import 'ticket_tokens.dart';

/// All queue state changes run through here.
///
/// The server is the only authority: ticket numbers, positions, ordering
/// and the ledger are computed and enforced here, never on the client.
/// Every operation in [QueueService] runs inside
/// [withQueueLock], except read-only views ([info], [ledger],
/// [verifyQueue], [checkReceipt]).
///
/// Counter provisioning ([addCounter]) is transactional and serialised but
/// appends no ledger entry: the ledger vocabulary (section 7 of the spec)
/// covers customer-visible ticket flow, and counter setup is not part of
/// it.
class QueueService {
  /// Maximum waiting tickets per queue.
  static const int waitingCap = 500;

  /// Bounds for the per-queue call timeout setting.
  static const int minCallTimeoutSec = 10;
  static const int maxCallTimeoutSec = 86400;

  /// The critical section: one database transaction that loads the [Queue]
  /// row `FOR UPDATE`, serialising all operations (and therefore the ledger
  /// chain) on one queue. The ledger append happens inside the same
  /// transaction. Realtime fan-out and FutureCall scheduling (M2/M3) happen
  /// after commit only, never in here.
  static Future<T> withQueueLock<T>(
    Session session,
    int queueId,
    Future<T> Function(Session session, Transaction transaction, Queue queue)
    operation,
  ) {
    return session.db.transaction((tx) async {
      final queue = await Queue.db.findById(
        session,
        queueId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (queue == null) {
        throw QueueError(message: 'Queue not found.');
      }
      return operation(session, tx, queue);
    });
  }

  /// Throws unless the signed-in user owns [queue].
  static void requireOwner(Session session, Queue queue) {
    final caller = session.authenticated?.authUserId;
    if (caller == null || caller != queue.ownerId) {
      throw QueueError(message: 'Only the queue owner can do that.');
    }
  }

  /// Data-minimised nicknames: trimmed, control characters removed, at most
  /// 24 characters. Pure so it is unit-testable.
  static String sanitizeNickname(String raw) {
    final cleaned = raw.trim().replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    final truncated = String.fromCharCodes(cleaned.runes.take(24));
    if (truncated.isEmpty) {
      throw QueueError(message: 'Nickname cannot be empty.');
    }
    return truncated;
  }

  static String _slugBase(String name) {
    final slug = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty ? 'queue' : slug;
  }

  static String _randomSuffix() {
    const alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(
      6,
      (_) => alphabet[random.nextInt(alphabet.length)],
    ).join();
  }

  /// Creates a queue owned by the signed-in user and opens its ledger.
  static Future<Queue> createQueue(
    Session session,
    String name,
    int callTimeoutSec,
  ) async {
    final caller = session.authenticated?.authUserId;
    if (caller == null) {
      throw QueueError(message: 'Sign in required.');
    }
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 80) {
      throw QueueError(message: 'Queue name must be 1-80 characters.');
    }
    if (callTimeoutSec < minCallTimeoutSec ||
        callTimeoutSec > maxCallTimeoutSec) {
      throw QueueError(
        message:
            'Call timeout must be $minCallTimeoutSec-'
            '$maxCallTimeoutSec seconds.',
      );
    }

    final base = _slugBase(trimmed);
    for (var attempt = 0; attempt < 8; attempt++) {
      final slug = '$base-${_randomSuffix()}';
      try {
        return await session.db.transaction((tx) async {
          final existing = await Queue.db.findFirstRow(
            session,
            where: (t) => t.slug.equals(slug),
            transaction: tx,
          );
          if (existing != null) {
            throw QueueError(message: 'Slug taken, retry.');
          }
          final queue = await Queue.db.insertRow(
            session,
            Queue(
              slug: slug,
              name: trimmed,
              status: QueueStatus.open,
              callTimeoutSec: callTimeoutSec,
              ownerId: caller,
            ),
            transaction: tx,
          );
          final appended = await LedgerService.append(
            session,
            tx,
            queue,
            type: LedgerType.queueOpened,
            detail: 'created',
          );
          return appended.queue;
        });
      } on QueueError catch (e) {
        if (e.message != 'Slug taken, retry.') rethrow;
      } catch (_) {
        // Unique-index race on slug: retry with a fresh suffix.
        if (attempt == 7) rethrow;
      }
    }
    throw QueueError(message: 'Could not pick a queue slug, try again.');
  }

  /// Adds a counter. Transactional and serialised; no ledger entry (see
  /// class docs for why).
  static Future<Counter> addCounter(
    Session session,
    int queueId,
    String name,
  ) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 40) {
      throw QueueError(message: 'Counter name must be 1-40 characters.');
    }
    final counter = await withQueueLock(
      session,
      queueId,
      (session, tx, queue) async {
        requireOwner(session, queue);
        return Counter.db.insertRow(
          session,
          Counter(queueId: queue.id!, name: trimmed),
          transaction: tx,
        );
      },
    );
    await notifyChanged(session, counter.queueId);
    return counter;
  }

  /// Opens, pauses or closes a queue, with a ledger entry.
  static Future<Queue> setStatus(
    Session session,
    int queueId,
    QueueStatus status,
  ) async {
    final result = await withQueueLock(session, queueId, (
      session,
      tx,
      queue,
    ) async {
      requireOwner(session, queue);
      if (queue.status == status) return queue;
      final updated = await Queue.db.updateRow(
        session,
        queue.copyWith(status: status),
        transaction: tx,
      );
      final LedgerType type;
      final String detail;
      switch (status) {
        case QueueStatus.paused:
          type = LedgerType.queuePaused;
          detail = 'from ${queue.status.name}';
        case QueueStatus.closed:
          type = LedgerType.queueClosed;
          detail = 'from ${queue.status.name}';
        case QueueStatus.open:
          type = LedgerType.queueOpened;
          detail = 'reopened from ${queue.status.name}';
      }
      final appended = await LedgerService.append(
        session,
        tx,
        updated,
        type: type,
        detail: detail,
      );
      return appended.queue;
    });
    await notifyChanged(session, result.id!);
    return result;
  }

  /// Joins the open queue with [slug]. Returns the receipt; the token inside
  /// is the only time the customer ever sees it.
  static Future<JoinReceipt> join(
    Session session,
    String slug,
    String nickname,
  ) {
    final clean = sanitizeNickname(nickname);
    return _withQueueLockBySlug(session, slug, (session, tx, queue) async {
      if (queue.status != QueueStatus.open) {
        throw QueueError(message: 'This queue is not open right now.');
      }
      final waiting = await Ticket.db.count(
        session,
        where: (t) =>
            t.queueId.equals(queue.id!) & t.status.equals(TicketStatus.waiting),
        transaction: tx,
      );
      if (waiting >= waitingCap) {
        throw QueueError(message: 'This queue is full, try again later.');
      }
      final number = queue.lastNumber + 1;
      final token = TicketTokens.generate();
      await Ticket.db.insertRow(
        session,
        Ticket(
          queueId: queue.id!,
          number: number,
          nickname: clean,
          tokenHash: TicketTokens.tokenHashFor(token),
          status: TicketStatus.waiting,
          orderKey: number.toDouble(),
        ),
        transaction: tx,
      );
      final numbered = await Queue.db.updateRow(
        session,
        queue.copyWith(lastNumber: number),
        transaction: tx,
      );
      final appended = await LedgerService.append(
        session,
        tx,
        numbered,
        type: LedgerType.joined,
        ticketNumber: number,
      );
      return JoinReceipt(
        number: number,
        token: token,
        joinSeq: appended.entry.seq,
        joinHash: appended.entry.hash,
      );
    });
  }

  /// Cancels the ticket identified by [token]. Only waiting or called
  /// tickets can leave; anything else is an error.
  static Future<void> leave(Session session, String token) async {
    final ticket = await Ticket.db.findFirstRow(
      session,
      where: (t) => t.tokenHash.equals(TicketTokens.tokenHashFor(token)),
    );
    if (ticket == null) {
      throw QueueError(message: 'Ticket not found.');
    }
    await withQueueLock(session, ticket.queueId, (session, tx, queue) async {
      final current = await Ticket.db.findById(
        session,
        ticket.id!,
        transaction: tx,
      );
      if (current == null) throw QueueError(message: 'Ticket not found.');
      if (current.status != TicketStatus.waiting &&
          current.status != TicketStatus.called) {
        throw QueueError(message: 'This ticket already left the queue.');
      }
      await Ticket.db.updateRow(
        session,
        current.copyWith(status: TicketStatus.cancelled),
        transaction: tx,
      );
      await LedgerService.append(
        session,
        tx,
        queue,
        type: LedgerType.cancelled,
        ticketNumber: current.number,
      );
    });
    await notifyChanged(session, ticket.queueId);
  }

  /// Calls the longest-waiting ticket to [counterId]. Returns the called
  /// ticket, or null when nobody is waiting. The row lock makes concurrent
  /// counters race-free: each ticket is called exactly once.
  static Future<Ticket?> callNext(Session session, int counterId) {
    return _withCounterLock(session, counterId, (
      session,
      tx,
      queue,
      counter,
    ) async {
      final next = await Ticket.db.findFirstRow(
        session,
        where: (t) =>
            t.queueId.equals(queue.id!) & t.status.equals(TicketStatus.waiting),
        orderBy: (t) => t.orderKey,
        transaction: tx,
      );
      if (next == null) return null;
      final called = await Ticket.db.updateRow(
        session,
        next.copyWith(
          status: TicketStatus.called,
          calledAt: DateTime.now().toUtc(),
          counterId: counter.id!,
          callId: next.callId + 1,
        ),
        transaction: tx,
      );
      await LedgerService.append(
        session,
        tx,
        queue,
        type: LedgerType.called,
        ticketNumber: called.number,
        counterId: counter.id!,
      );
      return _redacted(called);
    });
  }

  /// Moves a called ticket into service. Only staff move tickets here; a
  /// called customer is never auto-confirmed.
  static Future<Ticket> startServing(Session session, int ticketId) {
    return _withTicketLock(session, ticketId, (
      session,
      tx,
      queue,
      ticket,
    ) async {
      if (ticket.status != TicketStatus.called) {
        throw QueueError(message: 'Only a called ticket can start serving.');
      }
      final updated = await Ticket.db.updateRow(
        session,
        ticket.copyWith(
          status: TicketStatus.serving,
          servingAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
      await LedgerService.append(
        session,
        tx,
        queue,
        type: LedgerType.servingStarted,
        ticketNumber: updated.number,
        counterId: updated.counterId,
      );
      return _redacted(updated);
    });
  }

  /// Completes a serving ticket. With [callNext], the same counter
  /// immediately calls the next waiting ticket; the newly called ticket
  /// (or null) is returned.
  static Future<Ticket?> complete(
    Session session,
    int ticketId, {
    bool callNext = false,
  }) {
    return _withTicketLock(session, ticketId, (
      session,
      tx,
      queue,
      ticket,
    ) async {
      if (ticket.status != TicketStatus.serving) {
        throw QueueError(message: 'Only a serving ticket can complete.');
      }
      final updated = await Ticket.db.updateRow(
        session,
        ticket.copyWith(
          status: TicketStatus.done,
          doneAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
      final appended = await LedgerService.append(
        session,
        tx,
        queue,
        type: LedgerType.completed,
        ticketNumber: updated.number,
        counterId: updated.counterId,
      );
      if (callNext && updated.counterId != null) {
        return _callNextLocked(
          session,
          tx,
          appended.queue,
          updated.counterId!,
        );
      }
      return null;
    });
  }

  /// Takes a called (or serving) ticket out of the flow. Terminal.
  static Future<void> skip(Session session, int ticketId) {
    return _withTicketLock(session, ticketId, (
      session,
      tx,
      queue,
      ticket,
    ) async {
      if (ticket.status != TicketStatus.called &&
          ticket.status != TicketStatus.serving) {
        throw QueueError(message: 'Only a called ticket can be skipped.');
      }
      await Ticket.db.updateRow(
        session,
        ticket.copyWith(status: TicketStatus.skipped),
        transaction: tx,
      );
      await LedgerService.append(
        session,
        tx,
        queue,
        type: LedgerType.skipped,
        ticketNumber: ticket.number,
        counterId: ticket.counterId,
      );
    });
  }

  /// Public queue view: row, waiting count, counters. Read-only.
  static Future<QueueInfo> info(Session session, String slug) async {
    final queue = await _queueBySlug(session, slug);
    final waiting = await Ticket.db.count(
      session,
      where: (t) =>
          t.queueId.equals(queue.id!) & t.status.equals(TicketStatus.waiting),
    );
    final counters = await Counter.db.find(
      session,
      where: (t) => t.queueId.equals(queue.id!),
      orderBy: (t) => t.id,
    );
    return QueueInfo(queue: queue, waitingCount: waiting, counters: counters);
  }

  /// Public ledger page. [limit] is clamped to 1-200 entries.
  static Future<List<LedgerEntry>> ledger(
    Session session,
    String slug,
    int afterSeq,
    int limit,
  ) async {
    final queue = await _queueBySlug(session, slug);
    return LedgerEntry.db.find(
      session,
      where: (t) => t.queueId.equals(queue.id!) & (t.seq > afterSeq),
      orderBy: (t) => t.seq,
      limit: limit.clamp(1, 200),
    );
  }

  /// Recomputes the whole chain for public audit.
  static Future<VerifyResult> verifyQueue(Session session, String slug) async {
    final queue = await _queueBySlug(session, slug);
    final result = await LedgerService.verify(session, queue.id!);
    return VerifyResult(
      ok: result.ok,
      entryCount: result.entryCount,
      firstBadSeq: result.firstBadSeq,
    );
  }

  /// Checks a customer-held receipt against the chain.
  static Future<bool> checkReceipt(
    Session session,
    String slug,
    int seq,
    String hash,
  ) async {
    final queue = await _queueBySlug(session, slug);
    final entry = await LedgerEntry.db.findFirstRow(
      session,
      where: (t) => t.queueId.equals(queue.id!) & t.seq.equals(seq),
    );
    return entry != null && entry.hash == hash;
  }

  // -- realtime views -----------------------------------------------------

  /// Channel carrying "queue changed" pings for one queue. Messages carry
  /// no state; every open stream recomputes its own view from the database.
  static String channelFor(int queueId) => 'queue_$queueId';

  /// Publishes a change ping. Call only after the transaction commits,
  /// never inside it.
  static Future<void> notifyChanged(Session session, int queueId) async {
    await session.messages.postMessage(
      channelFor(queueId),
      QueueChanged(queueId: queueId),
    );
  }

  /// Queues owned by the signed-in user, oldest first.
  static Future<List<Queue>> myQueues(Session session) async {
    final caller = session.authenticated?.authUserId;
    if (caller == null) {
      throw QueueError(message: 'Sign in required.');
    }
    return Queue.db.find(
      session,
      where: (t) => t.ownerId.equals(caller),
      orderBy: (t) => t.id,
    );
  }

  /// Queue id behind [token]. Throws when the token is unknown.
  static Future<int> queueIdForToken(Session session, String token) async {
    final ticket = await Ticket.db.findFirstRow(
      session,
      where: (t) => t.tokenHash.equals(TicketTokens.tokenHashFor(token)),
    );
    if (ticket == null) throw QueueError(message: 'Ticket not found.');
    return ticket.queueId;
  }

  /// Live customer-facing view of the ticket behind [token].
  /// `etaSeconds` stays null until the M3 estimator lands.
  static Future<TicketView> ticketView(Session session, String token) async {
    final ticket = await Ticket.db.findFirstRow(
      session,
      where: (t) => t.tokenHash.equals(TicketTokens.tokenHashFor(token)),
    );
    if (ticket == null) throw QueueError(message: 'Ticket not found.');
    final queue = await Queue.db.findById(session, ticket.queueId);
    if (queue == null) throw QueueError(message: 'Queue not found.');

    var position = 0;
    if (ticket.status == TicketStatus.waiting) {
      position = await Ticket.db.count(
        session,
        where: (t) =>
            t.queueId.equals(queue.id!) &
            t.status.equals(TicketStatus.waiting) &
            (t.orderKey < ticket.orderKey),
      );
    }

    String? counterName;
    if (ticket.counterId != null) {
      final counter = await Counter.db.findById(session, ticket.counterId!);
      counterName = counter?.name;
    }

    int? arriveInSec;
    if (ticket.status == TicketStatus.called && ticket.calledAt != null) {
      final elapsed = DateTime.now().toUtc().difference(ticket.calledAt!);
      arriveInSec = (queue.callTimeoutSec - elapsed.inSeconds).clamp(
        0,
        queue.callTimeoutSec,
      );
    }

    final receipt = await LedgerEntry.db.findFirstRow(
      session,
      where: (t) =>
          t.queueId.equals(queue.id!) &
          t.ticketNumber.equals(ticket.number) &
          t.type.equals(LedgerType.joined),
      orderBy: (t) => t.seq,
    );

    return TicketView(
      queueId: queue.id!,
      queueSlug: queue.slug,
      queueName: queue.name,
      number: ticket.number,
      nickname: ticket.nickname,
      status: ticket.status,
      position: position,
      counterName: counterName,
      arriveInSec: arriveInSec,
      receiptSeq: receipt?.seq,
      receiptHash: receipt?.hash,
    );
  }

  /// Live staff-facing snapshot of [queueId].
  static Future<QueueSnapshot> queueSnapshot(
    Session session,
    int queueId,
  ) async {
    final queue = await Queue.db.findById(session, queueId);
    if (queue == null) throw QueueError(message: 'Queue not found.');
    final counters = await Counter.db.find(
      session,
      where: (t) => t.queueId.equals(queueId),
      orderBy: (t) => t.id,
    );
    final names = {for (final c in counters) c.id!: c.name};

    Future<List<TicketPublic>> byStatus(TicketStatus status) async {
      final tickets = await Ticket.db.find(
        session,
        where: (t) => t.queueId.equals(queueId) & t.status.equals(status),
        orderBy: (t) => t.orderKey,
      );
      return [
        for (final t in tickets)
          TicketPublic(
            id: t.id!,
            number: t.number,
            nickname: t.nickname,
            status: t.status,
            counterName: t.counterId == null ? null : names[t.counterId],
            calledAt: t.calledAt,
            servingAt: t.servingAt,
          ),
      ];
    }

    return QueueSnapshot(
      queueId: queue.id!,
      queueName: queue.name,
      slug: queue.slug,
      status: queue.status,
      waiting: await byStatus(TicketStatus.waiting),
      called: await byStatus(TicketStatus.called),
      serving: await byStatus(TicketStatus.serving),
      counters: counters,
      avgServiceSec: queue.avgServiceSec,
      sampleCount: queue.sampleCount,
    );
  }

  // -- internals ----------------------------------------------------------

  /// Token hashes must never leave the server.
  static Ticket _redacted(Ticket ticket) => ticket.copyWith(tokenHash: '');

  static Future<Queue> _queueBySlug(Session session, String slug) async {
    final queue = await Queue.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug),
    );
    if (queue == null) throw QueueError(message: 'Queue not found.');
    return queue;
  }

  static Future<T> _withQueueLockBySlug<T>(
    Session session,
    String slug,
    Future<T> Function(Session session, Transaction transaction, Queue queue)
    operation,
  ) async {
    final queue = await _queueBySlug(session, slug);
    final result = await withQueueLock(session, queue.id!, operation);
    // Fan-out after commit: watchers recompute their own views.
    await notifyChanged(session, queue.id!);
    return result;
  }

  static Future<T> _withCounterLock<T>(
    Session session,
    int counterId,
    Future<T> Function(
      Session session,
      Transaction transaction,
      Queue queue,
      Counter counter,
    )
    operation,
  ) async {
    final counter = await Counter.db.findById(session, counterId);
    if (counter == null) throw QueueError(message: 'Counter not found.');
    final queue = await Queue.db.findById(session, counter.queueId);
    if (queue == null) throw QueueError(message: 'Queue not found.');
    requireOwner(session, queue);
    final result = await withQueueLock(
      session,
      queue.id!,
      (session, tx, locked) async {
        final current = await Counter.db.findById(
          session,
          counterId,
          transaction: tx,
        );
        if (current == null || !current.active) {
          throw QueueError(message: 'Counter is not available.');
        }
        return operation(session, tx, locked, current);
      },
    );
    await notifyChanged(session, queue.id!);
    return result;
  }

  static Future<T> _withTicketLock<T>(
    Session session,
    int ticketId,
    Future<T> Function(
      Session session,
      Transaction transaction,
      Queue queue,
      Ticket ticket,
    )
    operation,
  ) async {
    final ticket = await Ticket.db.findById(session, ticketId);
    if (ticket == null) throw QueueError(message: 'Ticket not found.');
    final queue = await Queue.db.findById(session, ticket.queueId);
    if (queue == null) throw QueueError(message: 'Queue not found.');
    requireOwner(session, queue);
    final result = await withQueueLock(
      session,
      queue.id!,
      (session, tx, locked) async {
        final current = await Ticket.db.findById(
          session,
          ticketId,
          transaction: tx,
        );
        if (current == null) throw QueueError(message: 'Ticket not found.');
        return operation(session, tx, locked, current);
      },
    );
    await notifyChanged(session, queue.id!);
    return result;
  }

  static Future<Ticket?> _callNextLocked(
    Session session,
    Transaction tx,
    Queue queue,
    int counterId,
  ) async {
    final counter = await Counter.db.findById(session, counterId);
    if (counter == null || !counter.active) return null;
    final next = await Ticket.db.findFirstRow(
      session,
      where: (t) =>
          t.queueId.equals(queue.id!) & t.status.equals(TicketStatus.waiting),
      orderBy: (t) => t.orderKey,
      transaction: tx,
    );
    if (next == null) return null;
    final called = await Ticket.db.updateRow(
      session,
      next.copyWith(
        status: TicketStatus.called,
        calledAt: DateTime.now().toUtc(),
        counterId: counter.id!,
        callId: next.callId + 1,
      ),
      transaction: tx,
    );
    await LedgerService.append(
      session,
      tx,
      queue,
      type: LedgerType.called,
      ticketNumber: called.number,
      counterId: counter.id!,
    );
    return _redacted(called);
  }
}
