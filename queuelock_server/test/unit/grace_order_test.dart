import 'package:queuelock_server/src/services/queue_service.dart';
import 'package:test/test.dart';

void main() {
  group('Given the grace re-insertion rule', () {
    test('then an empty queue keeps the ticket number', () {
      expect(QueueService.reinsertOrderKey([], 7), 7);
    });

    test('then fewer than 3 waiting go behind the maximum', () {
      expect(QueueService.reinsertOrderKey([2], 9), 3);
      expect(QueueService.reinsertOrderKey([1, 2], 9), 3);
      expect(QueueService.reinsertOrderKey([1, 5], 9), 6);
    });

    test('then exactly 3 waiting go one past the third', () {
      expect(QueueService.reinsertOrderKey([1, 2, 3], 9), 4);
    });

    test('then more than 3 waiting split the 3rd and 4th', () {
      expect(QueueService.reinsertOrderKey([1, 2, 3, 4], 9), 3.5);
      expect(QueueService.reinsertOrderKey([1, 2, 3, 5], 9), 4.0);
      expect(QueueService.reinsertOrderKey([2, 4, 6, 8, 10], 9), 7.0);
    });

    test('then repeated re-insertions stay ordered without colliding', () {
      final first = QueueService.reinsertOrderKey([1, 2, 3], 9);
      final keys = [1.0, 2.0, 3.0, first]..sort();
      final second = QueueService.reinsertOrderKey(keys, 10);
      expect(second, greaterThan(3));
      expect(second, lessThan(4));
    });
  });
}
