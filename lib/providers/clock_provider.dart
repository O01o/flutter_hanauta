import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hanauta/providers/flag_provider.dart';
import 'package:flutter_hanauta/providers/sample_rate_provider.dart';

import 'package:just_audio/just_audio.dart';

final clockProvider = StreamProvider.autoDispose((ref) async* {
  while (true) {
    int duration = ref.watch(countProvider);
    await Future.delayed(Duration(milliseconds: duration));
    if (ref.watch(clockFlagProvider)) {
      print("clock!!");
      // play clock sound
    }
  }
});