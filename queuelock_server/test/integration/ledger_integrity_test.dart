// M1 ledger proof: the chain verifies, tampering is located exactly,
// and customer receipts check out. Own group (own database) because the
// tamper test commits a corrupted row on purpose.
import 'package:queuelock_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _ownerId = '33333333-3333-4333-8333-333333333333';

void main() {
  withServerpod(
    'Given a queue with real traffic',
    (sessionBuilder, endpoints) {
      final owner = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _ownerId,
          {},
        ),
      );

      test(
        'when traffic flows then the chain verifies and receipts check out',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Ledger Test',
            callTimeoutSec: 180,
          );
          final counter = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );

          final receipts = <JoinReceipt>[];
          for (var i = 0; i < 3; i++) {
            receipts.add(
              await endpoints.queue.join(sessionBuilder, queue.slug, 'p$i'),
            );
          }
          final called = (await endpoints.counter.callNext(
            owner,
            counter.id!,
          ))!;
          await endpoints.counter.startServing(owner, called.id!);
          await endpoints.counter.complete(owner, called.id!, callNext: false);

          // queue_opened + 3 joined + called + serving_started + completed
          final result = await endpoints.audit.verify(
            sessionBuilder,
            queue.slug,
          );
          expect(result.ok, isTrue);
          expect(result.firstBadSeq, isNull);
          expect(result.entryCount, 7);

          for (final receipt in receipts) {
            expect(
              await endpoints.audit.checkReceipt(
                sessionBuilder,
                queue.slug,
                receipt.joinSeq,
                receipt.joinHash,
              ),
              isTrue,
            );
          }
          expect(
            await endpoints.audit.checkReceipt(
              sessionBuilder,
              queue.slug,
              receipts.first.joinSeq,
              '0' * 64,
            ),
            isFalse,
          );

          // The ledger page shows the same entries in order.
          final page = await endpoints.audit.ledger(
            sessionBuilder,
            queue.slug,
            afterSeq: 0,
            limit: 100,
          );
          expect(page.map((e) => e.seq).toList(), [1, 2, 3, 4, 5, 6, 7]);
        },
      );

      test(
        'when one row is altered then verify fails at exactly that seq',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Tamper Test',
            callTimeoutSec: 180,
          );
          await endpoints.queue.join(sessionBuilder, queue.slug, 'a');
          await endpoints.queue.join(sessionBuilder, queue.slug, 'b');
          await endpoints.queue.join(sessionBuilder, queue.slug, 'c');

          final session = sessionBuilder.build();
          final entries = await LedgerEntry.db.find(
            session,
            where: (t) => t.queueId.equals(queue.id!),
            orderBy: (t) => t.seq,
          );
          expect(entries, hasLength(4));
          await LedgerEntry.db.updateRow(
            session,
            entries[2].copyWith(hash: 'f' * 64),
          );

          final result = await endpoints.audit.verify(
            sessionBuilder,
            queue.slug,
          );
          expect(result.ok, isFalse);
          expect(result.firstBadSeq, 3);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
