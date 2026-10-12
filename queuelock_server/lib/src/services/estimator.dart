import 'dart:math';

class Estimator {
  static const double priorAvgServiceSec = 300;

  static ({double avg, int count}) nextAverage({
    required double avg,
    required int sampleCount,
    required double sample,
  }) {
    final alpha = max(0.2, 1 / (sampleCount + 1));
    return (avg: avg + alpha * (sample - avg), count: sampleCount + 1);
  }

  static int? etaSeconds({
    required int waitingAhead,
    required int activeCounters,
    required double avgServiceSec,
    required bool allCountersBusy,
    required int sampleCount,
  }) {
    if (sampleCount == 0) return null;
    final lanes = max(activeCounters, 1);
    var eta = (waitingAhead / lanes) * avgServiceSec;
    if (allCountersBusy) eta += avgServiceSec / 2;
    return eta.round();
  }
}
