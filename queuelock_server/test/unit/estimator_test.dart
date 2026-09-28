import 'package:queuelock_server/src/services/estimator.dart';
import 'package:test/test.dart';

void main() {
  group('Given the EWMA average', () {
    test('then the first sample replaces the prior entirely', () {
      expect(
        Estimator.nextAverage(avg: 300, sampleCount: 0, sample: 120),
        (avg: 120, count: 1),
      );
    });

    test('then the second sample moves halfway', () {
      expect(
        Estimator.nextAverage(avg: 120, sampleCount: 1, sample: 180),
        (avg: 150, count: 2),
      );
    });

    test('then late samples move by the 0.2 floor', () {
      final next = Estimator.nextAverage(avg: 150, sampleCount: 9, sample: 160);
      expect(next.avg, closeTo(152, 1e-9));
      expect(next.count, 10);
    });
  });

  group('Given the ETA rule', () {
    test('then zero samples means no estimate', () {
      expect(
        Estimator.etaSeconds(
          waitingAhead: 5,
          activeCounters: 2,
          avgServiceSec: 120,
          allCountersBusy: false,
          sampleCount: 0,
        ),
        isNull,
      );
    });

    test('then load spreads across counters', () {
      expect(
        Estimator.etaSeconds(
          waitingAhead: 6,
          activeCounters: 2,
          avgServiceSec: 120,
          allCountersBusy: false,
          sampleCount: 5,
        ),
        360,
      );
    });

    test('then busy counters add half a service', () {
      expect(
        Estimator.etaSeconds(
          waitingAhead: 6,
          activeCounters: 2,
          avgServiceSec: 120,
          allCountersBusy: true,
          sampleCount: 5,
        ),
        420,
      );
    });

    test('then zero counters still divide by one', () {
      expect(
        Estimator.etaSeconds(
          waitingAhead: 6,
          activeCounters: 0,
          avgServiceSec: 120,
          allCountersBusy: false,
          sampleCount: 5,
        ),
        720,
      );
    });

    test('then nobody ahead means zero', () {
      expect(
        Estimator.etaSeconds(
          waitingAhead: 0,
          activeCounters: 3,
          avgServiceSec: 120,
          allCountersBusy: false,
          sampleCount: 5,
        ),
        0,
      );
    });
  });
}
