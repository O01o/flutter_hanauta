import 'package:flutter/material.dart';
import 'package:flutter_hanauta/logic/recorder_init.dart';
import 'dart:core';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hanauta/providers/recording_providers.dart';
import 'package:flutter_hanauta/style.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:flutter_hanauta/widgets/dialogs/file_save_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_hanauta/utils/add_save_path.dart';


class RecordingScreen extends HookConsumerWidget {
  RecordingScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final audioRecorder = FlutterSoundRecorder();
    String savePath = "";

    useEffect(() {
      recorderInit();
      audioRecorder.openRecorder();
      return () {
        audioRecorder.closeRecorder();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                        String saveFileName = "record.wav";
                        String saveFilePath = "${await saveDirectoryPath("wav")}/$saveFileName";
                        await audioRecorder.startRecorder(
                          toFile: saveFilePath
                        );
                        print("start recording!!");
                      } else if (audioRecorder.isRecording && ref.watch(recordingFlagProvider)) {
                        ref.watch(recordingFlagProvider.notifier).switching();
                        await audioRecorder.stopRecorder();
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return const FileSaveDialog();
                          }
                        );
                        print("stop recording!!");
                      } else {
                        print("not responding...");
                        if (audioRecorder.isRecording) print("is recording");
                        if (ref.watch(recordingFlagProvider)) print("flag ok");
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