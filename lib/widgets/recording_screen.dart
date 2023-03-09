import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hanauta/providers/flag_provider.dart';
import 'package:flutter_hanauta/style.dart';
import 'package:flutter_sound/flutter_sound.dart';


class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends ConsumerState<RecordingScreen> {
  final FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    audioRecorder.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ElevatedButton(
                  child: ref.watch(recordingFlagProvider)
                  ? const Text("録音を止める")
                  : const Text("録音する"),
                  style: styleColorToggle(ref.watch(recordingFlagProvider)),
                  onPressed: () async {
                    ref.watch(recordingFlagProvider.notifier).switching();
                  }
                ),

              ]
            )
          )
        ],
      )
    );
  }
}