import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/queue_service.dart';

class QueueEndpoint extends Endpoint {
  Future<JoinReceipt> join(Session session, String slug, String nickname) {
    return QueueService.join(
      session,
      slug,
      nickname,
      remoteIp: _remoteIp(session),
    );
  }

  static String? _remoteIp(Session session) {
    try {
      return session.request?.remoteInfo;
    } catch (_) {
      return null;
    }
  }

  Future<void> leave(Session session, String token) {
    return QueueService.leave(session, token);
  }

  Future<QueueInfo> info(Session session, String slug) {
    return QueueService.info(session, slug);
  }

  Stream<TicketView> watch(Session session, String token) async* {
    final queueId = await QueueService.queueIdForToken(session, token);
    final updates = session.messages.createStream<QueueChanged>(
      QueueService.channelFor(queueId),
    );
    yield await QueueService.ticketView(session, token);
    await for (final _ in updates) {
      yield await QueueService.ticketView(session, token);
    }
  }
}
