import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

void alertOnCalled() {
  if (!kIsWeb) return;
  try {
    web.window.navigator.vibrate([200.toJS, 100.toJS, 200.toJS].toJS);
  } catch (_) {}
  try {
    final context = web.AudioContext();
    final oscillator = context.createOscillator();
    oscillator.frequency.value = 880;
    final gain = context.createGain();
    gain.gain.value = 0.15;
    oscillator.connect(gain);
    gain.connect(context.destination);
    oscillator.start();
    oscillator.stop(context.currentTime + 0.6);
    Future.delayed(const Duration(seconds: 1), () {
      try {
        context.close();
      } catch (_) {}
    });
  } catch (_) {}
}
