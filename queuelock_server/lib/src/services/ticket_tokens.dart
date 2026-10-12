import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class TicketTokens {
  static final Random _random = Random.secure();

  static String generate() {
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return base64Url.encode(bytes);
  }

  static String tokenHashFor(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }
}
