// M1 concurrency proof.
//
// These tests run against a real booted server (test run mode, embedded
// PostgreSQL) with `rollbackDatabase: disabled`, so every endpoint call
// runs in its own real transaction. `Future.wait` fires the calls
// concurrently; the `FOR UPDATE` queue lock in `QueueService.withQueueLock`
// is what serialises them. Each `withServerpod` group gets its own
// database, so committed rows never leak between groups.
import 'package:queuelock_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _ownerId = '11111111-1111-4111-8111-111111111111';

void main() {
  withServerpod(
    'Given an open queue',
    (sessionBuilder, endpoints) {
      final owner = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _ownerId,
          {},
        ),
      );

      test(
        'when 50 customers join concurrently then numbers are unique and gap-free 1-50',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Load Test',
            callTimeoutSec: 180,
          );

          final receipts = await Future.wait(
            List.generate(
              50,
              (i) => endpoints.queue.join(sessionBuilder, queue.slug, 'c$i'),
            ),
          );

          final numbers = receipts.map((r) => r.number).toList()..sort();
          expect(numbers, List.generate(50, (i) => i + 1));

          // Every receipt checks out against the chain.
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

          final result = await endpoints.audit.verify(
            sessionBuilder,
            queue.slug,
          );
          expect(result.ok, isTrue);
          expect(result.entryCount, 51); // queue_opened + 50 joined
        },
      );

      test(
        'when two counters call concurrently then each ticket is called exactly once',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Race Test',
            callTimeoutSec: 180,
          );
          final counterA = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );
          final counterB = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'B',
          );
          await Future.wait(
            List.generate(
              40,
              (i) => endpoints.queue.join(sessionBuilder, queue.slug, 'w$i'),
            ),
          );

          final calls = <Future>[];
          for (var i = 0; i < 20; i++) {
            calls.add(endpoints.counter.callNext(owner, counterA.id!));
            calls.add(endpoints.counter.callNext(owner, counterB.id!));
          }
          final called = (await Future.wait(
            calls,
          )).whereType<Ticket>().toList();
          expect(called, hasLength(40));

          final numbers = called.map((t) => t.number).toList()..sort();
          expect(numbers, List.generate(40, (i) => i + 1));

          // No ticket hash ever leaves the server, even to staff.
          for (final t in called) {
            expect(t.tokenHash, isEmpty);
          }

          // Queue is drained: the next call finds nobody waiting.
          expect(
            await endpoints.counter.callNext(owner, counterA.id!),
            isNull,
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
