import 'package:serverpod/serverpod.dart';

import '../services/queue_service.dart';

/// Fires once per call at `now + queue.callTimeoutSec`.
///
/// Future calls run at least once, so the handler ([QueueService
/// .applyCallTimeout]) is idempotent: it acts only when the ticket is
/// still `called` with the same [callId], and does nothing otherwise.
class CallTimeoutFutureCall extends FutureCall {
  Future<void> timeoutTicket(Session session, int ticketId, int callId) async {
    await QueueService.applyCallTimeout(session, ticketId, callId);
  }
}
