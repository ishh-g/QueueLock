// M1 lifecycle + ownership proof: every transition in the ticket
// lifecycle, invalid transitions rejected, and staff calls from a
// non-owner rejected. Public endpoints reject invalid tokens.
import 'package:queuelock_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _ownerId = '55555555-5555-4555-8555-555555555555';
const _intruderId = '66666666-6666-4666-8666-666666666666';

void main() {
  withServerpod(
    'Given an owned queue',
    (sessionBuilder, endpoints) {
      final owner = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _ownerId,
          {},
        ),
      );
      final intruder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _intruderId,
          {},
        ),
      );
      final anonymous = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );

      test(
        'when tickets flow then each transition lands exactly once',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Flow Test',
            callTimeoutSec: 180,
          );
          final counter = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );

          final receipt = await endpoints.queue.join(
            sessionBuilder,
            queue.slug,
            'Zoya',
          );
          expect(receipt.number, 1);

          var info = await endpoints.queue.info(sessionBuilder, queue.slug);
          expect(info.waitingCount, 1);
          expect(info.counters, hasLength(1));

          final called = (await endpoints.counter.callNext(
            owner,
            counter.id!,
          ))!;
          expect(called.number, 1);
          expect(called.status, TicketStatus.called);

          final serving = await endpoints.counter.startServing(
            owner,
            called.id!,
          );
          expect(serving.status, TicketStatus.serving);

          await endpoints.counter.complete(
            owner,
            serving.id!,
            callNext: false,
          );

          info = await endpoints.queue.info(sessionBuilder, queue.slug);
          expect(info.waitingCount, 0);

          // Terminal transitions reject repeats.
          await expectLater(
            endpoints.counter.complete(owner, serving.id!, callNext: false),
            throwsA(isA<QueueError>()),
          );
          await expectLater(
            endpoints.counter.startServing(owner, called.id!),
            throwsA(isA<QueueError>()),
          );
          await expectLater(
            endpoints.queue.leave(sessionBuilder, receipt.token),
            throwsA(isA<QueueError>()),
          );
        },
      );

      test('when waiting then leave cancels and skip is rejected', () async {
        final queue = await endpoints.admin.createQueue(
          owner,
          'Leave Test',
          callTimeoutSec: 180,
        );
        final counter = await endpoints.admin.addCounter(
          owner,
          queue.id!,
          'A',
        );
        final receipt = await endpoints.queue.join(
          sessionBuilder,
          queue.slug,
          'Kabir',
        );
        await endpoints.queue.leave(sessionBuilder, receipt.token);
        final info = await endpoints.queue.info(sessionBuilder, queue.slug);
        expect(info.waitingCount, 0);

        final receipt2 = await endpoints.queue.join(
          sessionBuilder,
          queue.slug,
          'Meera',
        );
        final called = (await endpoints.counter.callNext(
          owner,
          counter.id!,
        ))!;
        expect(called.number, receipt2.number);
        await endpoints.counter.skip(owner, called.id!);
        await expectLater(
          endpoints.queue.leave(sessionBuilder, receipt2.token),
          throwsA(isA<QueueError>()),
        );
      });

      test(
        'when completing with callNext then the same counter calls the next ticket',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Chained Test',
            callTimeoutSec: 180,
          );
          final counter = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );
          final first = await endpoints.queue.join(
            sessionBuilder,
            queue.slug,
            'Dev',
          );
          final second = await endpoints.queue.join(
            sessionBuilder,
            queue.slug,
            'Esha',
          );

          final called = (await endpoints.counter.callNext(
            owner,
            counter.id!,
          ))!;
          expect(called.number, first.number);
          await endpoints.counter.startServing(owner, called.id!);

          final next = await endpoints.counter.complete(
            owner,
            called.id!,
            callNext: true,
          );
          expect(next, isNotNull);
          expect(next!.number, second.number);
          expect(next.status, TicketStatus.called);
          expect(next.counterId, counter.id!);

          final info = await endpoints.queue.info(sessionBuilder, queue.slug);
          expect(info.waitingCount, 0);
        },
      );

      test('when serving then skip takes the ticket out of the flow', () async {
        final queue = await endpoints.admin.createQueue(
          owner,
          'Skip Serving Test',
          callTimeoutSec: 180,
        );
        final counter = await endpoints.admin.addCounter(
          owner,
          queue.id!,
          'A',
        );
        await endpoints.queue.join(sessionBuilder, queue.slug, 'Farhan');
        final called = (await endpoints.counter.callNext(
          owner,
          counter.id!,
        ))!;
        await endpoints.counter.startServing(owner, called.id!);
        await endpoints.counter.skip(owner, called.id!);
        await expectLater(
          endpoints.counter.startServing(owner, called.id!),
          throwsA(isA<QueueError>()),
        );
      });

      test('when called then the customer can still leave', () async {
        final queue = await endpoints.admin.createQueue(
          owner,
          'Leave Called Test',
          callTimeoutSec: 180,
        );
        final counter = await endpoints.admin.addCounter(
          owner,
          queue.id!,
          'A',
        );
        final receipt = await endpoints.queue.join(
          sessionBuilder,
          queue.slug,
          'Gita',
        );
        final called = (await endpoints.counter.callNext(
          owner,
          counter.id!,
        ))!;
        expect(called.number, receipt.number);
        await endpoints.queue.leave(sessionBuilder, receipt.token);
        await expectLater(
          endpoints.counter.startServing(owner, called.id!),
          throwsA(isA<QueueError>()),
        );
      });

      test('when the queue is closed then join is rejected', () async {
        final queue = await endpoints.admin.createQueue(
          owner,
          'Closed Test',
          callTimeoutSec: 180,
        );
        await endpoints.admin.setStatus(owner, queue.id!, QueueStatus.closed);
        await expectLater(
          endpoints.queue.join(sessionBuilder, queue.slug, 'Noor'),
          throwsA(isA<QueueError>()),
        );
        await endpoints.admin.setStatus(owner, queue.id!, QueueStatus.open);
        final receipt = await endpoints.queue.join(
          sessionBuilder,
          queue.slug,
          'Noor',
        );
        expect(receipt.number, 1);
      });

      test(
        'when staff is not the owner then staff calls are rejected',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Auth Test',
            callTimeoutSec: 180,
          );
          final counter = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );

          await expectLater(
            endpoints.counter.callNext(intruder, counter.id!),
            throwsA(isA<QueueError>()),
          );
          await expectLater(
            endpoints.admin.addCounter(intruder, queue.id!, 'B'),
            throwsA(isA<QueueError>()),
          );
          await expectLater(
            endpoints.admin.setStatus(intruder, queue.id!, QueueStatus.paused),
            throwsA(isA<QueueError>()),
          );
          await expectLater(
            endpoints.counter.callNext(anonymous, counter.id!),
            throwsA(isA<ServerpodUnauthenticatedException>()),
          );
          await expectLater(
            endpoints.admin.createQueue(anonymous, 'Nope', callTimeoutSec: 180),
            throwsA(isA<ServerpodUnauthenticatedException>()),
          );
        },
      );

      test(
        'when the token is invalid then public endpoints reject it',
        () async {
          await expectLater(
            endpoints.queue.leave(sessionBuilder, 'bogus-token'),
            throwsA(isA<QueueError>()),
          );
          await expectLater(
            endpoints.queue.info(sessionBuilder, 'no-such-queue'),
            throwsA(isA<QueueError>()),
          );
          await expectLater(
            endpoints.audit.verify(sessionBuilder, 'no-such-queue'),
            throwsA(isA<QueueError>()),
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
