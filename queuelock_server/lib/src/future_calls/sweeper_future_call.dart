import 'package:serverpod/serverpod.dart';

import '../services/queue_service.dart';

class SweeperFutureCall extends FutureCall {
  Future<void> sweep(Session session) async {
    await QueueService.sweepCalledTimeouts(session);
    await QueueService.purgeOldNicknames(session);
    await QueueService.pruneRateLimitHits(session);
  }
}
