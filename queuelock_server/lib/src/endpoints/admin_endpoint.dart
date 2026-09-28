import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

/// Staff admin endpoints. MVP: owner-only; every call checks that the
/// signed-in user owns the queue.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a queue owned by the signed-in user. [callTimeoutSec] is the
  /// per-queue "come to the counter" grace period (minimum 10 seconds).
  Future<Queue> createQueue(
    Session session,
    String name, {
    int callTimeoutSec = 180,
  }) {
    return QueueService.createQueue(session, name, callTimeoutSec);
  }

  /// Adds a named counter to [queueId].
  Future<Counter> addCounter(Session session, int queueId, String name) {
    return QueueService.addCounter(session, queueId, name);
  }

  /// Opens, pauses or closes [queueId].
  Future<Queue> setStatus(Session session, int queueId, QueueStatus status) {
    return QueueService.setStatus(session, queueId, status);
  }
}
