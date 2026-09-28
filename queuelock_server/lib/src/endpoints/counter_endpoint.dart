import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

/// Staff counter endpoints. The signed-in user must own the queue; the
/// owner can sign in on several devices and each device picks a counter.
class CounterEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Calls the longest-waiting ticket to [counterId]. Returns the called
  /// ticket, or null when nobody is waiting.
  Future<Ticket?> callNext(Session session, int counterId) {
    return QueueService.callNext(session, counterId);
  }

  /// Moves a called ticket into service.
  Future<Ticket> startServing(Session session, int ticketId) {
    return QueueService.startServing(session, ticketId);
  }

  /// Completes a serving ticket. With [callNext], the same counter
  /// immediately calls the next waiting ticket, which is returned
  /// (or null when nobody is waiting).
  Future<Ticket?> complete(
    Session session,
    int ticketId, {
    bool callNext = false,
  }) {
    return QueueService.complete(session, ticketId, callNext: callNext);
  }

  /// Takes a called (or serving) ticket out of the flow.
  Future<void> skip(Session session, int ticketId) {
    return QueueService.skip(session, ticketId);
  }

  /// Live queue stream for the counter dashboard. Emits a fresh
  /// server-computed [QueueSnapshot] immediately and on every change.
  Stream<QueueSnapshot> watchQueue(Session session, int queueId) async* {
    final queue = await Queue.db.findById(session, queueId);
    if (queue == null) throw QueueError(message: 'Queue not found.');
    QueueService.requireOwner(session, queue);
    final updates = session.messages.createStream<QueueChanged>(
      QueueService.channelFor(queueId),
    );
    yield await QueueService.queueSnapshot(session, queueId);
    await for (final _ in updates) {
      yield await QueueService.queueSnapshot(session, queueId);
    }
  }
}
