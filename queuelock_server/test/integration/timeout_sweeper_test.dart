import 'package:queuelock_server/src/generated/protocol.dart';
import 'package:queuelock_server/src/services/queue_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'wait_for.dart';

const _ownerId = '88888888-8888-4888-8888-888888888888';

void main() {
  withServerpod(
    'Given call timeouts',
    (sessionBuilder, endpoints) {
      final owner = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _ownerId,
          {},
        ),
      );

      test(
        'when a call is missed then the ticket returns behind three others',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Timeout Test',
            callTimeoutSec: 10,
          );
          final counter = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );
          await Future.wait(
            List.generate(
              5,
              (i) => endpoints.queue.join(sessionBuilder, queue.slug, 't$i'),
            ),
          );

          QueueSnapshot? latest;
          final sub = endpoints.counter
              .watchQueue(owner, queue.id!)
              .listen((snapshot) => latest = snapshot);

          final called = (await endpoints.counter.callNext(
            owner,
            counter.id!,
          ))!;
          expect(called.number, 1);

          final session = sessionBuilder.build();
          final scheduled = await session.db.unsafeQuery(
            "SELECT name, \"serializedObject\" FROM serverpod_future_call "
            "WHERE name = 'CallTimeoutTimeoutTicketFutureCall'",
          );
          expect(
            scheduled.any(
              (row) => row.join(',').contains('"ticketId":${called.id}'),
            ),
            isTrue,
          );

          final stored = (await Ticket.db.findById(session, called.id!))!;
          await Ticket.db.updateRow(
            session,
            stored.copyWith(
              calledAt: DateTime.now().toUtc().subtract(
                const Duration(seconds: 15),
              ),
            ),
          );
          await QueueService.sweepCalledTimeouts(session);

          await waitForCondition(
            () =>
                latest != null &&
                latest!.waiting.length == 5 &&
                latest!.waiting[3].number == 1,
            what: 'ticket 1 re-entered behind three others',
            timeout: const Duration(seconds: 30),
          );

          final entries = await endpoints.audit.ledger(
            sessionBuilder,
            queue.slug,
            afterSeq: 0,
            limit: 200,
          );
          expect(
            entries.any(
              (e) => e.type == LedgerType.reentered && e.ticketNumber == 1,
            ),
            isTrue,
          );
          await sub.cancel();
        },
      );

      test(
        'when a call is missed twice then the ticket is skipped, idempotently',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Second Miss Test',
            callTimeoutSec: 10,
          );
          final counter = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );
          await Future.wait(
            List.generate(
              5,
              (i) => endpoints.queue.join(sessionBuilder, queue.slug, 's$i'),
            ),
          );

          var first = (await endpoints.counter.callNext(
            owner,
            counter.id!,
          ))!;
          expect(first.number, 1);
          var session = sessionBuilder.build();
          var stored = (await Ticket.db.findById(session, first.id!))!;
          await Ticket.db.updateRow(
            session,
            stored.copyWith(
              calledAt: DateTime.now().toUtc().subtract(
                const Duration(seconds: 120),
              ),
            ),
          );
          expect(
            await QueueService.applyCallTimeout(session, first.id!, 1),
            isTrue,
          );

          for (var i = 0; i < 3; i++) {
            final next = (await endpoints.counter.callNext(
              owner,
              counter.id!,
            ))!;
            await endpoints.counter.skip(owner, next.id!);
          }
          final recalled = (await endpoints.counter.callNext(
            owner,
            counter.id!,
          ))!;
          expect(recalled.number, 1);
          expect(recalled.callId, 2);

          session = sessionBuilder.build();
          stored = (await Ticket.db.findById(session, recalled.id!))!;
          await Ticket.db.updateRow(
            session,
            stored.copyWith(
              calledAt: DateTime.now().toUtc().subtract(
                const Duration(seconds: 120),
              ),
            ),
          );
          expect(
            await QueueService.applyCallTimeout(session, recalled.id!, 2),
            isTrue,
          );

          QueueSnapshot? latest;
          final sub = endpoints.counter
              .watchQueue(owner, queue.id!)
              .listen((snapshot) => latest = snapshot);
          await waitForCondition(
            () =>
                latest != null &&
                latest!.waiting.every((t) => t.number != 1) &&
                latest!.called.isEmpty,
            what: 'ticket 1 skipped out of the queue',
          );
          await sub.cancel();

          final entries = await endpoints.audit.ledger(
            sessionBuilder,
            queue.slug,
            afterSeq: 0,
            limit: 200,
          );
          expect(
            entries.any(
              (e) => e.type == LedgerType.skipped && e.ticketNumber == 1,
            ),
            isTrue,
          );

          final countBefore = entries.length;
          expect(
            await QueueService.applyCallTimeout(session, recalled.id!, 2),
            isFalse,
          );
          expect(
            await QueueService.applyCallTimeout(session, recalled.id!, 999),
            isFalse,
          );
          final after = await endpoints.audit.ledger(
            sessionBuilder,
            queue.slug,
            afterSeq: 0,
            limit: 200,
          );
          expect(after.length, countBefore);
          final result = await endpoints.audit.verify(
            sessionBuilder,
            queue.slug,
          );
          expect(result.ok, isTrue);
        },
      );

      test('when nicknames age past 24h then retention purges them', () async {
        final queue = await endpoints.admin.createQueue(
          owner,
          'Retention Test',
          callTimeoutSec: 180,
        );
        final receipt = await endpoints.queue.join(
          sessionBuilder,
          queue.slug,
          'OldNick',
        );
        expect(receipt.number, 1);

        final session = sessionBuilder.build();
        final tickets = await Ticket.db.find(
          session,
          where: (t) => t.queueId.equals(queue.id!),
        );
        await Ticket.db.updateRow(
          session,
          tickets.first.copyWith(
            joinedAt: DateTime.now().toUtc().subtract(
              const Duration(hours: 25),
            ),
          ),
        );

        expect(await QueueService.purgeOldNicknames(session), 1);
        expect(await QueueService.purgeOldNicknames(session), 0);

        final result = await endpoints.audit.verify(
          sessionBuilder,
          queue.slug,
        );
        expect(result.ok, isTrue);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
