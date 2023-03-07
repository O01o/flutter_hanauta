import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_hanauta/style.dart';
import 'package:flutter_hanauta/providers/wav2midi_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

class Wav2MidiScreen extends ConsumerWidget {
  const Wav2MidiScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  final int sampleRate = 8000;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = Dio();
    final audioPlayer = AudioPlayer();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Text("ファイル名: ${ref.watch(fileNameProvider)}"),
                ElevatedButton(
                  child: const Text("ファイルを選択"),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.audio
                    );
                    if (result == null) return;

                    ref.watch(fileNameProvider.notifier).state = result.files.single.path!;
                  }
                ),
                const Spacer(),
                Text("BPM: ${sampleRate*(60/4) / (16*ref.watch(countProvider)) ~/ 0.01 / 100}"),
                Text("♬ length: ${ref.watch(countProvider)}"),
                Slider(
                  value: ref.watch(countProvider).toDouble(), 
                  onChanged: (newRate) {
                    ref.watch(countProvider.notifier).state = newRate.toInt();
                  },
                  min: 40,
                  max: 100,
                ),
                ElevatedButton(
                  child: ref.watch(acappellaFlagProvider)
                  ? const Text("アカペラを止める")
                  : const Text("アカペラを演奏する"),
                  style: styleColorToggle(ref.watch(acappellaFlagProvider)),
                  onPressed: () { 
                    ref.watch(acappellaFlagProvider.notifier).switching();
                  }
                ),
                ElevatedButton(
                  child: ref.watch(clockFlagProvider)
                  ? const Text("クロックを止める")
                  : const Text("クロックを演奏する"),
                  style: styleColorToggle(ref.watch(clockFlagProvider)),
                  onPressed: () {
                    ref.watch(clockFlagProvider.notifier).switching();
                  }
                ),
                ElevatedButton(
                  child: const Text("WAV→MIDI変換する"),
                  onPressed: () async {
                    if (ref.watch(fileNameProvider) == "no file...") {
                      return;
                    }

                    final formData = FormData.fromMap({
                      'hop_length': 16 * ref.watch(countProvider),
                      'file': await MultipartFile.fromFile(ref.watch(fileNameProvider))
                    });
                    
                    // final response = await dio.get("https://hanauta-7xlrbzh3ba-an.a.run.app/");
                    final response = await dio.post("https://hanauta-7xlrbzh3ba-an.a.run.app/", data: formData);
                    
                    print(response.data.toString());
                    
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
