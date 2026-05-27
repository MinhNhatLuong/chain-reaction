import 'package:vibration/vibration.dart';

class HapticService {
  Future<void> lightImpact() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 15, amplitude: 60);
    }
  }

  Future<void> mediumImpact() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 30, amplitude: 128);
    }
  }

  Future<void> heavyImpact() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 50, amplitude: 255);
    }
  }

  Future<void> explosionPattern() async {
    if (await Vibration.hasVibrator()) {
      // Pattern: wait, vibrate, wait, vibrate...
      await Vibration.vibrate(pattern: [0, 20, 30, 40]);
    }
  }
}
