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
// import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';

class Wav2MidiScreen extends ConsumerStatefulWidget {
  const Wav2MidiScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Wav2MidiScreenState createState() => Wav2MidiScreenState();
}

class Wav2MidiScreenState extends ConsumerState<Wav2MidiScreen> {
  final int sampleRate = 8000;
  final FlutterSoundPlayer recordPlayer = FlutterSoundPlayer();
  String assetPath = "";
  
  @override
  void initState() {
    super.initState();
    
    // transfer asset data to app document directory
    /*
    final documentPathDirectory = await ref.watch(filePathProvider.future);
    final assetPathString = await ref.watch(assetPathProvider.future);
    File clockSoundFile = File(assetPathString);
    clockSoundFile.copySync(documentPathDirectory.path);
    */
    recordPlayer.openPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    recordPlayer.closePlayer();
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  child: ref.watch(clockFlagProvider)
                  ? const Text("クロックを止める")
                  : const Text("クロックを演奏する"),
                  style: styleColorToggle(ref.watch(clockFlagProvider)),
                  onPressed: () {
                    ref.watch(clockFlagProvider.notifier).switching();
                    // clockPlayer.seek(Duration(milliseconds: 1000 * 16 * ref.watch(countProvider) ~/ sampleRate));
                  }
                ),
                ElevatedButton(
                  child: ref.watch(acappellaFlagProvider)
                  ? const Text("アカペラを止める")
                  : const Text("アカペラを演奏する"),
                  style: styleColorToggle(ref.watch(acappellaFlagProvider)),
                  onPressed: () { 
                    ref.watch(acappellaFlagProvider.notifier).switching();
                    if (recordPlayer.isStopped && ref.watch(acappellaFlagProvider) && ref.watch(fileNameProvider) != "") {
                      recordPlayer.startPlayer();
                      print("start player!!");
                    } else if (recordPlayer.isPlaying) {
                      recordPlayer.stopPlayer();
                      print("stop player!!");
                    } else {
                      print("not responding...");
                    }
                  }
                ),
                ElevatedButton(
                  child: const Text("WAV→MIDI変換する"),
                  onPressed: () async {
                    if (ref.watch(fileNameProvider) == "") {
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
