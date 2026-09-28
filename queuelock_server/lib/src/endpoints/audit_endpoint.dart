import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

/// Public audit endpoints. Anyone can recompute a queue's ledger chain
/// and check a receipt against it.
class AuditEndpoint extends Endpoint {
  /// Ledger page after [afterSeq], up to [limit] entries (clamped 1-200).
  Future<List<LedgerEntry>> ledger(
    Session session,
    String slug, {
    int afterSeq = 0,
    int limit = 100,
  }) {
    return QueueService.ledger(session, slug, afterSeq, limit);
  }

  /// Recomputes the whole chain. `firstBadSeq` locates tampering exactly.
  Future<VerifyResult> verify(Session session, String slug) {
    return QueueService.verifyQueue(session, slug);
  }

  /// Checks a customer-held `(seq, hash)` receipt against the chain.
  Future<bool> checkReceipt(
    Session session,
    String slug,
    int seq,
    String hash,
  ) {
    return QueueService.checkReceipt(session, slug, seq, hash);
  }
}
