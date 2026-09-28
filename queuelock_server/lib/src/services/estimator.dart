import 'dart:math';

/// Wait-time estimator. All inputs come from real service history; when
/// there are no samples yet there is no estimate (null) and the UI says
/// so instead of inventing a number.
class Estimator {
  /// EWMA starting prior, in seconds (spec: 300).
  static const double priorAvgServiceSec = 300;

  /// Folds one observed service duration into the running average.
  /// `alpha = max(0.2, 1 / (sampleCount + 1))`.
  static ({double avg, int count}) nextAverage({
    required double avg,
    required int sampleCount,
    required double sample,
  }) {
    final alpha = max(0.2, 1 / (sampleCount + 1));
    return (avg: avg + alpha * (sample - avg), count: sampleCount + 1);
  }

  /// Estimated seconds until the ticket at `waitingAhead` is called.
  /// Null when no service has been observed yet.
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
