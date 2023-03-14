import 'dart:async';

import 'package:flutter/material.dart';
import 'widgets/screens/all_screens.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomeScreen(title: "Home Screen"),
        "/recording": (context) => const RecordingScreen(title: "Recording Screen"),
        "/wav2midi": (context) => const Wav2MidiScreen(title: "WAV2MIDI Screen"),
      },
    );
  }
}