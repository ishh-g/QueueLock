import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Customer ticket tokens.
///
/// A token is 32 random bytes, base64url-encoded, shown once in the ticket
/// URL (`/t/<token>`). Only the SHA-256 hash is stored ([tokenHashFor]);
/// tickets are looked up by hash. Neither tokens nor nicknames are logged.
class TicketTokens {
  static final Random _random = Random.secure();

  /// Generates a fresh token to hand to the customer exactly once.
  static String generate() {
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Hashes a token for storage and lookup. The plain token never touches
  /// the database.
  static String tokenHashFor(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }
}
