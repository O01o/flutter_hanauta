import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hanauta/providers/recording_providers.dart';
import 'package:flutter_hanauta/style.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:flutter_hanauta/widgets/dialogs/file_save_dialog.dart';


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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
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
                      if (audioRecorder.isStopped && !ref.watch(recordingFlagProvider)) {
                        ref.watch(recordingFlagProvider.notifier).switching();
                        audioRecorder.startRecorder();
                        print("start recording!!");
                      } else if (audioRecorder.isRecording && ref.watch(recordingFlagProvider)) {
                        ref.watch(recordingFlagProvider.notifier).switching();
                        audioRecorder.stopRecorder();
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return const FileSaveDialog();
                          }
                        );
                        print("stop recording!!");
                      } else {
                        print("not responding...");
                      }
                    }
                  )
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}