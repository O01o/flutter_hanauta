import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_hanauta/style.dart';
import 'package:flutter_hanauta/providers/wav2midi_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class Wav2MidiScreen extends ConsumerWidget {
  const Wav2MidiScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int sampleRate = 8000;
    final dio = Dio();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Text("ファイル名: ${ref.watch(fileProvider).path}"),
                ElevatedButton(
                  child: const Text("ファイルを選択"),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.audio,
                      allowedExtensions: ['mp3', 'wav']
                    );
                    if (result == null) return;

                    ref.watch(fileProvider.notifier).state = File(result.files.single.path!);
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
                  min: 25,
                  max: 100,
                ),
                ElevatedButton(
                  child: Text(ref.watch(acappellaFlagProvider)
                  ? "アカペラを止める"
                  : "アカペラを演奏する"
                  ),
                  style: styleColorToggle(ref.watch(recordingFlagProvider)),
                  onPressed: () => ref.watch(acappellaFlagProvider.notifier).switching(),
                ),
                ElevatedButton(
                  child: Text(ref.watch(clockFlagProvider)
                  ? "クロックを止める"
                  : "クロックを演奏する"
                  ),
                  style: styleColorToggle(ref.watch(recordingFlagProvider)),
                  onPressed: () => ref.watch(clockFlagProvider.notifier).switching()
                ),
                ElevatedButton(
                  child: const Text("WAV→MIDI変換する"),
                  onPressed: () async {
                    final response = await dio.get("http://127.0.0.1:8000");
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

/*
  double count = 100;
  static int sampleRate = 8000;
  late double bpm = sampleRate*(60/4) / (16*count);

  String fileName = "No Selected...";

  bool tik = false;
  late var timer = Timer.periodic(
    Duration(milliseconds: 1000),
    (_) {
      if (tik) {
        print("Tik!!!");
      }
    }
  );

  void incrementCounter() {
    setState(() {
      count++;
      bpm = sampleRate*(60/4) / (16*count);
    });
  }

  void decrementCounter() {
    setState(() {
      count--;
      bpm = sampleRate*(60/4) / (16*count);
    });
  }

  bool switchTik() {
    setState(() {
      tik = !tik;
    });
    return tik;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("FileName: $fileName"),
            Text('count: $count, BPM: $bpm'),
            ElevatedButton(
              child: const  Text("-"),
              onPressed: decrementCounter
            ),
            ElevatedButton(
              child: const Text("+"),
              onPressed: incrementCounter
            ),
            Switch(value: false, onChanged: null),      
            ElevatedButton(
              child: const Text("Choose File"),
              onPressed: () async {
                // final result = await FilePicker.platform.pickFiles();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/