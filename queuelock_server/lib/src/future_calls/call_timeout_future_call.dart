import 'package:serverpod/serverpod.dart';

import '../services/queue_service.dart';

class CallTimeoutFutureCall extends FutureCall {
  Future<void> timeoutTicket(Session session, int ticketId, int callId) async {
    await QueueService.applyCallTimeout(session, ticketId, callId);
  }
}
