import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hanauta/providers/flag_provider.dart';
import 'package:flutter_hanauta/providers/sample_rate_provider.dart';
import 'package:flutter_hanauta/providers/file_path_provider.dart';

// import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';

int sampleRate = 8000;

final clockProvider = StreamProvider.autoDispose.family<void, FlutterSoundPlayer>((ref, clockPlayer) async* {
  String assetPath = await ref.watch(assetPathProvider.future);
  while (true) {
    int duration = 1000 * 16 * ref.watch(countProvider) ~/ sampleRate;
    await Future.delayed(Duration(milliseconds: duration));
    if (ref.watch(clockFlagProvider)) {
      await clockPlayer.startPlayer(
        fromURI: assetPath
      );
    }
  }
});