import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:queuelock_server/src/generated/protocol.dart';
import 'package:queuelock_server/src/services/ledger_service.dart';
import 'package:queuelock_server/src/services/queue_service.dart';
import 'package:queuelock_server/src/services/ticket_tokens.dart';
import 'package:test/test.dart';

void main() {
  group('Given the ledger hash rule', () {
    test('then the golden vector is stable', () {
      expect(
        LedgerService.hashFor(
          queueId: 7,
          seq: 1,
          type: 'joined',
          ticketNumber: 3,
          tsMs: 1750000000000,
          prevHash: LedgerService.genesisPrevHash,
        ),
        '4f3b72dedaf8e1e6b0a130f8d8690568b44f78baffad7e57a1a7a125bf9d0bbf',
      );
    });

    test('then it matches a plain SHA-256 of the spec string', () {
      const input =
          '7|1|joined|3|-|-|1750000000000|'
          '0000000000000000000000000000000000000000000000000000000000000000';
      expect(
        LedgerService.hashFor(
          queueId: 7,
          seq: 1,
          type: 'joined',
          ticketNumber: 3,
          tsMs: 1750000000000,
          prevHash: LedgerService.genesisPrevHash,
        ),
        sha256.convert(utf8.encode(input)).toString(),
      );
    });

    test('then any single-field change avalanches the hash', () {
      String h({int? ticketNumber, int? counterId, String? detail}) =>
          LedgerService.hashFor(
            queueId: 7,
            seq: 1,
            type: 'joined',
            ticketNumber: ticketNumber,
            counterId: counterId,
            detail: detail,
            tsMs: 1,
            prevHash: LedgerService.genesisPrevHash,
          );
      final base = h(ticketNumber: 3);
      expect(base, hasLength(64));
      expect(h(ticketNumber: 4), isNot(base));
      expect(h(counterId: 9), isNot(base));
      expect(h(detail: 'x'), isNot(base));
      expect(h(), isNot(base));
    });
  });

  group('Given nickname sanitising', () {
    test('then plain names pass through', () {
      expect(QueueService.sanitizeNickname('  Aarav  '), 'Aarav');
    });

    test('then control characters are stripped', () {
      expect(QueueService.sanitizeNickname('a\x00b\x1Fc\x7F'), 'abc');
    });

    test('then long names are cut at 24 characters', () {
      expect(
        QueueService.sanitizeNickname('abcdefghijklmnopqrstuvwxyz'),
        'abcdefghijklmnopqrstuvwx',
      );
    });

    test('then empty names are rejected', () {
      expect(
        () => QueueService.sanitizeNickname('   \x00 '),
        throwsA(isA<QueueError>()),
      );
    });
  });

  group('Given ticket tokens', () {
    test('then generated tokens are 32 random bytes and hashes are stable', () {
      final a = TicketTokens.generate();
      final b = TicketTokens.generate();
      expect(a, isNot(b));
      expect(base64.decode(base64.normalize(a)), hasLength(32));
      expect(TicketTokens.tokenHashFor(a), TicketTokens.tokenHashFor(a));
      expect(TicketTokens.tokenHashFor(a), isNot(a));
      expect(TicketTokens.tokenHashFor(a), hasLength(64));
    });
  });
}
