import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Appends entries to a queue's tamper-evident ledger.
///
/// Must only be called from inside [QueueService.withQueueLock], on the
/// locked [Queue] row, using the same transaction. The caller updates no
/// ledger state itself; [append] increments `headSeq`, computes the hash
/// chain link and persists the updated head on the queue row atomically
/// with the state change.
///
/// Hash (SHA-256 hex, `crypto` package):
/// `sha256("$queueId|$seq|$type|ticket| counter|detail|$tsMs|$prevHash")`
/// with `-` for absent optional fields. The genesis `prevHash` is 64 zeros.
/// `tsMs` is hashed as the stored integer, never as a round-tripped
/// `DateTime`.
class LedgerService {
  /// Genesis link: 64 zeros.
  static const String genesisPrevHash =
      '0000000000000000000000000000000000000000000000000000000000000000';

  /// Pure hash computation, so the chain rule is unit-testable and shared
  /// by [append] and audit verification.
  static String hashFor({
    required int queueId,
    required int seq,
    required String type,
    int? ticketNumber,
    int? counterId,
    String? detail,
    required int tsMs,
    required String prevHash,
  }) {
    final input =
        '$queueId|$seq|$type|${ticketNumber ?? '-'}|${counterId ?? '-'}|'
        '${detail ?? '-'}|$tsMs|$prevHash';
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Appends one entry and advances the queue head. Returns the entry
  /// together with the queue row carrying the new head, so chained
  /// appends in the same transaction never reuse a stale `headSeq`.
  static Future<({LedgerEntry entry, Queue queue})> append(
    Session session,
    Transaction transaction,
    Queue queue, {
    required LedgerType type,
    int? ticketNumber,
    int? counterId,
    String? detail,
  }) async {
    final seq = queue.headSeq + 1;
    final prevHash = queue.headSeq == 0 ? genesisPrevHash : queue.headHash;
    final tsMs = DateTime.now().toUtc().millisecondsSinceEpoch;
    final hash = hashFor(
      queueId: queue.id!,
      seq: seq,
      type: type.name,
      ticketNumber: ticketNumber,
      counterId: counterId,
      detail: detail,
      tsMs: tsMs,
      prevHash: prevHash,
    );

    final entry = await LedgerEntry.db.insertRow(
      session,
      LedgerEntry(
        queueId: queue.id!,
        seq: seq,
        type: type,
        ticketNumber: ticketNumber,
        counterId: counterId,
        detail: detail,
        tsMs: tsMs,
        prevHash: prevHash,
        hash: hash,
      ),
      transaction: transaction,
    );

    final updatedQueue = await Queue.db.updateRow(
      session,
      queue.copyWith(headSeq: seq, headHash: hash),
      transaction: transaction,
    );

    return (entry: entry, queue: updatedQueue);
  }

  /// Recomputes the whole chain for [queueId]. Returns `(ok, firstBadSeq)`.
  /// A bad link at `seq` also breaks every later link; the first one is
  /// reported so tampering is located exactly.
  static Future<({bool ok, int? firstBadSeq, int entryCount})> verify(
    Session session,
    int queueId, {
    Transaction? transaction,
  }) async {
    final entries = await LedgerEntry.db.find(
      session,
      where: (t) => t.queueId.equals(queueId),
      orderBy: (t) => t.seq,
      transaction: transaction,
    );

    var prevHash = genesisPrevHash;
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final expectedSeq = i + 1;
      final expectedHash = hashFor(
        queueId: queueId,
        seq: entry.seq,
        type: entry.type.name,
        ticketNumber: entry.ticketNumber,
        counterId: entry.counterId,
        detail: entry.detail,
        tsMs: entry.tsMs,
        prevHash: entry.prevHash,
      );
      if (entry.seq != expectedSeq ||
          entry.prevHash != prevHash ||
          entry.hash != expectedHash) {
        return (ok: false, firstBadSeq: entry.seq, entryCount: entries.length);
      }
      prevHash = entry.hash;
    }
    return (ok: true, firstBadSeq: null, entryCount: entries.length);
  }
}
