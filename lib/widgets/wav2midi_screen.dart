import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

import 'package:flutter_hanauta/providers/wav2midi_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wav2MidiScreen extends ConsumerWidget {
  const Wav2MidiScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int sampleRate = 8000;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Text("ファイル名: {filename}"),
                ElevatedButton(
                  child: const Text("ファイルを選択する"),
                  onPressed: () {}
                ),
                const Spacer(),
                Text("BPM: ${sampleRate*(60/4) / (16*ref.watch(countProvider))}"),
                Slider(
                  value: ref.watch(countProvider), 
                  onChanged: (newRate) {
                    ref.watch(countProvider.notifier).state = newRate;
                  },
                  min: 30,
                  max: 300,
                ),
                ElevatedButton(
                  child: Text(ref.watch(acappellaFlagProvider)
                  ? "アカペラを止める"
                  : "アカペラを演奏する"
                  ),
                  onPressed: () => ref.watch(acappellaFlagProvider.notifier).switching(),
                ),
                ElevatedButton(
                  child: Text(ref.watch(clockFlagProvider)
                  ? "クロックを止める"
                  : "クロックを演奏する"
                  ),
                  onPressed: () => ref.watch(clockFlagProvider.notifier).switching()
                ),
                ElevatedButton(
                  child: const Text("ファイルを選択する"),
                  onPressed: () {}
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