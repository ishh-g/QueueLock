@Timeout(Duration(minutes: 3))
library;

// M5 hardening proof: the join rate limit and the waiting cap.
//
// The rate limit keys on the caller address, which only exists on real
// HTTP sessions, so those checks call QueueService.join directly with an
// explicit address. Endpoint-level joins (address unknown in tests) skip
// the limiter — proven implicitly by every other integration test doing
// more than 10 joins.
import 'package:queuelock_server/src/generated/protocol.dart';
import 'package:queuelock_server/src/services/queue_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _ownerId = '99999999-9999-4999-8999-999999999999';

void main() {
  withServerpod(
    'Given abuse protection',
    (sessionBuilder, endpoints) {
      final owner = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _ownerId,
          {},
        ),
      );

      test(
        'when one address joins 11 times in a minute then the 11th is rejected',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Rate Test',
            callTimeoutSec: 180,
          );
          final session = sessionBuilder.build();
          for (var i = 0; i < 10; i++) {
            await QueueService.join(
              session,
              queue.slug,
              'r$i',
              remoteIp: 'rate-test-ip-1',
            );
          }
          await expectLater(
            QueueService.join(
              session,
              queue.slug,
              'r10',
              remoteIp: 'rate-test-ip-1',
            ),
            throwsA(isA<QueueError>()),
          );
          // A different address is unaffected.
          final ok = await QueueService.join(
            session,
            queue.slug,
            'other',
            remoteIp: 'rate-test-ip-2',
          );
          expect(ok.number, 11);
        },
      );

      test(
        'when 500 wait then the 501st is rejected until someone leaves',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Cap Test',
            callTimeoutSec: 180,
          );
          final receipts = <JoinReceipt>[];
          for (var batch = 0; batch < 10; batch++) {
            final chunk = await Future.wait(
              List.generate(
                50,
                (i) => endpoints.queue.join(
                  sessionBuilder,
                  queue.slug,
                  'w${batch * 50 + i}',
                ),
              ),
            );
            receipts.addAll(chunk);
          }
          final numbers = receipts.map((r) => r.number).toList()..sort();
          expect(numbers, List.generate(500, (i) => i + 1));

          await expectLater(
            endpoints.queue.join(sessionBuilder, queue.slug, 'extra'),
            throwsA(isA<QueueError>()),
          );

          await endpoints.queue.leave(sessionBuilder, receipts.first.token);
          final backIn = await endpoints.queue.join(
            sessionBuilder,
            queue.slug,
            'back',
          );
          expect(backIn.number, 501);

          final info = await endpoints.queue.info(sessionBuilder, queue.slug);
          expect(info.waitingCount, 500);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
