import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class LedgerService {
  static const String genesisPrevHash =
      '0000000000000000000000000000000000000000000000000000000000000000';

  static String hashFor({
    required int queueId,
    required int seq,
    required String type,
    int? ticketNumber,
    int? counterId,
    String? detail,
    required int tsMs,
    required String prevHash,
  }) {
    final input =
        '$queueId|$seq|$type|${ticketNumber ?? '-'}|${counterId ?? '-'}|'
        '${detail ?? '-'}|$tsMs|$prevHash';
    return sha256.convert(utf8.encode(input)).toString();
  }

  static Future<({LedgerEntry entry, Queue queue})> append(
    Session session,
    Transaction transaction,
    Queue queue, {
    required LedgerType type,
    int? ticketNumber,
    int? counterId,
    String? detail,
  }) async {
    final seq = queue.headSeq + 1;
    final prevHash = queue.headSeq == 0 ? genesisPrevHash : queue.headHash;
    final tsMs = DateTime.now().toUtc().millisecondsSinceEpoch;
    final hash = hashFor(
      queueId: queue.id!,
      seq: seq,
      type: type.name,
      ticketNumber: ticketNumber,
      counterId: counterId,
      detail: detail,
      tsMs: tsMs,
      prevHash: prevHash,
    );

    final entry = await LedgerEntry.db.insertRow(
      session,
      LedgerEntry(
        queueId: queue.id!,
        seq: seq,
        type: type,
        ticketNumber: ticketNumber,
        counterId: counterId,
        detail: detail,
        tsMs: tsMs,
        prevHash: prevHash,
        hash: hash,
      ),
      transaction: transaction,
    );

    final updatedQueue = await Queue.db.updateRow(
      session,
      queue.copyWith(headSeq: seq, headHash: hash),
      transaction: transaction,
    );

    return (entry: entry, queue: updatedQueue);
  }

  static Future<({bool ok, int? firstBadSeq, int entryCount})> verify(
    Session session,
    int queueId, {
    Transaction? transaction,
  }) async {
    final entries = await LedgerEntry.db.find(
      session,
      where: (t) => t.queueId.equals(queueId),
      orderBy: (t) => t.seq,
      transaction: transaction,
    );

    var prevHash = genesisPrevHash;
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final expectedSeq = i + 1;
      final expectedHash = hashFor(
        queueId: queueId,
        seq: entry.seq,
        type: entry.type.name,
        ticketNumber: entry.ticketNumber,
        counterId: entry.counterId,
        detail: entry.detail,
        tsMs: entry.tsMs,
        prevHash: entry.prevHash,
      );
      if (entry.seq != expectedSeq ||
          entry.prevHash != prevHash ||
          entry.hash != expectedHash) {
        return (ok: false, firstBadSeq: entry.seq, entryCount: entries.length);
      }
      prevHash = entry.hash;
    }
    return (ok: true, firstBadSeq: null, entryCount: entries.length);
  }
}
