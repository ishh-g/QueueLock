import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

/// Public customer endpoints. No sign-in; customers are identified by
/// ticket tokens. Thin: input validation lives here, rules in
/// [QueueService].
class QueueEndpoint extends Endpoint {
  /// Joins the open queue [slug] with [nickname]. Returns the receipt;
  /// the token is shown to the customer exactly once.
  Future<JoinReceipt> join(Session session, String slug, String nickname) {
    return QueueService.join(session, slug, nickname);
  }

  /// Cancels the ticket identified by [token].
  Future<void> leave(Session session, String token) {
    return QueueService.leave(session, token);
  }

  /// Public queue view: row, waiting count, counters.
  Future<QueueInfo> info(Session session, String slug) {
    return QueueService.info(session, slug);
  }
}
