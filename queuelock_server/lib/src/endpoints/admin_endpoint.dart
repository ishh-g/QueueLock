import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Queue> createQueue(
    Session session,
    String name, {
    int callTimeoutSec = 180,
  }) {
    return QueueService.createQueue(session, name, callTimeoutSec);
  }

  Future<Counter> addCounter(Session session, int queueId, String name) {
    return QueueService.addCounter(session, queueId, name);
  }

  Future<Queue> setStatus(Session session, int queueId, QueueStatus status) {
    return QueueService.setStatus(session, queueId, status);
  }

  Future<List<Queue>> myQueues(Session session) {
    return QueueService.myQueues(session);
  }
}
