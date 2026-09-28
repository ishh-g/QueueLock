// Polling helper shared by integration tests (not a test itself).
import 'dart:async';

Future<void> waitForCondition(
  bool Function() done, {
  required String what,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!done()) {
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('Timed out waiting for $what');
    }
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
