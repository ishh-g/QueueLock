import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

class CounterEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Ticket?> callNext(Session session, int counterId) {
    return QueueService.callNext(session, counterId);
  }

  Future<Ticket> startServing(Session session, int ticketId) {
    return QueueService.startServing(session, ticketId);
  }

  Future<Ticket?> complete(
    Session session,
    int ticketId, {
    bool callNext = false,
  }) {
    return QueueService.complete(session, ticketId, callNext: callNext);
  }

  Future<void> skip(Session session, int ticketId) {
    return QueueService.skip(session, ticketId);
  }

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
