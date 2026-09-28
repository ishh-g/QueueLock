import 'package:serverpod/serverpod.dart';

import '../services/queue_service.dart';

/// Runs every 60 seconds.
///
/// Applies call timeouts that were missed between commit and scheduling
/// (crash window) and purges nicknames older than 24 hours. Both halves
/// are idempotent; running twice changes nothing.
class SweeperFutureCall extends FutureCall {
  Future<void> sweep(Session session) async {
    await QueueService.sweepCalledTimeouts(session);
    await QueueService.purgeOldNicknames(session);
  }
}
