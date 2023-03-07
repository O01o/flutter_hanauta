import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hanauta/providers/flag_provider.dart';
import 'package:flutter_hanauta/providers/sample_rate_provider.dart';

import 'package:just_audio/just_audio.dart';

int sampleRate = 8000;

final clockProvider = StreamProvider.autoDispose((ref) async* {
  final clockPlayer = AudioPlayer();
  clockPlayer.setAsset("assets/sounds/clock_cut.wav");
  while (true) {
    int duration = 1000 * 16 * ref.watch(countProvider) ~/ sampleRate;
    await Future.delayed(Duration(milliseconds: duration));
    if (ref.watch(clockFlagProvider)) {
      
    }
  }
});