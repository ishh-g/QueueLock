import 'dart:io';

import 'package:queuelock_server/server.dart' as app;
import 'package:queuelock_server/src/generated/serverpod.dart' as generated;
import 'package:queuelock_server/src/services/queue_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

const _demoEmail = 'demo@queuelock.local';
const _demoPassword = 'Demo-pass-1234';
const _demoQueueName = 'Demo Queue';
const _demoTimeoutSec = 20;

void _say(Object? message) => stdout.writeln(message);

Future<void> main(List<String> args) async {
  final pod = generated.Serverpod(args);
  await app.configureAppServices(pod);
  await pod.start();
  try {
    await pod.withSession((session) async {
      final admin = AuthServices.instance.emailIdp.admin;
      final existing = await admin.findAccount(session, email: _demoEmail);
      final UuidValue ownerId;
      if (existing != null) {
        ownerId = existing.authUserId;
        await admin.setPassword(
          session,
          email: _demoEmail,
          password: _demoPassword,
        );
        _say('Demo owner already exists: $_demoEmail');
      } else {
        final user = await AuthServices.instance.authUsers.create(session);
        await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: user.id,
          email: _demoEmail,
          password: _demoPassword,
        );
        ownerId = user.id;
        _say('Demo owner created: $_demoEmail / $_demoPassword');
      }
      session.updateAuthenticated(
        AuthenticationInfo(ownerId.toString(), {}, authId: const Uuid().v4()),
      );
      final queue = await QueueService.createQueue(
        session,
        _demoQueueName,
        _demoTimeoutSec,
      );
      _say(
        'Demo queue created: ${queue.name} '
        'slug=${queue.slug} timeout=${queue.callTimeoutSec}s',
      );
      _say('Join at /q/${queue.slug} - audit at /audit/${queue.slug}');
    });
  } finally {
    await pod.shutdown(exitProcess: false);
  }
}
