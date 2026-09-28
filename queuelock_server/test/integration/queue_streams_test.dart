// M2 realtime proof: open streams emit fresh server-computed views as
// state changes, with no polling. Same real-server setup as the other
// integration groups (own database, real transactions).
import 'package:queuelock_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _ownerId = '77777777-7777-4777-8777-777777777777';

Future<void> _waitFor(
  bool Function() done, {
  required String what,
}) async {
  final deadline = DateTime.now().add(const Duration(seconds: 15));
  while (!done()) {
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('Timed out waiting for $what');
    }
    await Future.delayed(const Duration(milliseconds: 50));
  }
}

void main() {
  withServerpod(
    'Given live streams',
    (sessionBuilder, endpoints) {
      final owner = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _ownerId,
          {},
        ),
      );

      test(
        'when the ticket moves then watch emits fresh views',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Watch Test',
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
            'Hina',
          );

          TicketView? latest;
          final sub = endpoints.queue
              .watch(sessionBuilder, receipt.token)
              .listen((view) => latest = view);

          await _waitFor(() => latest != null, what: 'initial view');
          expect(latest!.status, TicketStatus.waiting);
          expect(latest!.position, 0);
          expect(latest!.receiptSeq, receipt.joinSeq);
          expect(latest!.receiptHash, receipt.joinHash);

          await endpoints.counter.callNext(owner, counter.id!);
          await _waitFor(
            () => latest != null && latest!.status == TicketStatus.called,
            what: 'called view',
          );
          expect(latest!.counterName, 'A');
          expect(latest!.arriveInSec, isNotNull);

          await sub.cancel();
        },
      );

      test(
        'when customers join and are called then watchQueue snapshots follow',
        () async {
          final queue = await endpoints.admin.createQueue(
            owner,
            'Snapshot Test',
            callTimeoutSec: 180,
          );
          final counter = await endpoints.admin.addCounter(
            owner,
            queue.id!,
            'A',
          );

          QueueSnapshot? latest;
          final sub = endpoints.counter
              .watchQueue(owner, queue.id!)
              .listen((snapshot) => latest = snapshot);

          await _waitFor(() => latest != null, what: 'initial snapshot');
          expect(latest!.waiting, isEmpty);

          final receipt = await endpoints.queue.join(
            sessionBuilder,
            queue.slug,
            'Ishaan',
          );
          await _waitFor(
            () => latest != null && latest!.waiting.length == 1,
            what: 'joined snapshot',
          );
          expect(latest!.waiting.first.number, receipt.number);
          expect(latest!.waiting.first.nickname, 'Ishaan');

          final called = (await endpoints.counter.callNext(
            owner,
            counter.id!,
          ))!;
          await _waitFor(
            () => latest != null && latest!.called.length == 1,
            what: 'called snapshot',
          );
          expect(latest!.called.first.number, called.number);
          expect(latest!.waiting, isEmpty);

          await sub.cancel();
        },
      );

      test(
        'when the token is invalid then watch closes with an error',
        () async {
          await expectLater(
            endpoints.queue.watch(sessionBuilder, 'bogus-token').first,
            throwsA(isA<QueueError>()),
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
