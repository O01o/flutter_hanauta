import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockFlagProvider = StateNotifierProvider.autoDispose<FlagNotifier, bool>((ref) => FlagNotifier(ref));
final acappellaFlagProvider = StateNotifierProvider.autoDispose<FlagNotifier, bool>((ref) => FlagNotifier(ref));
final recordingFlagProvider = StateNotifierProvider.autoDispose<FlagNotifier, bool>((ref) => FlagNotifier(ref));
final wav2midiDisableFlagProvider = StateNotifierProvider.autoDispose<FlagNotifier, bool>((ref) => FlagNotifier(ref));

class FlagNotifier extends StateNotifier<bool> {
  FlagNotifier(ref): super(false);

  void switching() {
    state = !state;
  }
}