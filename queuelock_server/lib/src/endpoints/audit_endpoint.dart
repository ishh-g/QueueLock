import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

class AuditEndpoint extends Endpoint {
  Future<List<LedgerEntry>> ledger(
    Session session,
    String slug, {
    int afterSeq = 0,
    int limit = 100,
  }) {
    return QueueService.ledger(session, slug, afterSeq, limit);
  }

  Future<VerifyResult> verify(Session session, String slug) {
    return QueueService.verifyQueue(session, slug);
  }

  Future<bool> checkReceipt(
    Session session,
    String slug,
    int seq,
    String hash,
  ) {
    return QueueService.checkReceipt(session, slug, seq, hash);
  }
}
