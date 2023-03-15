import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:core';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:flutter_hanauta/style.dart';
import 'package:flutter_hanauta/providers/wav2midi_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Wav2MidiScreen extends ConsumerStatefulWidget {
  const Wav2MidiScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Wav2MidiScreenState createState() => Wav2MidiScreenState();
}

class Wav2MidiScreenState extends ConsumerState<Wav2MidiScreen> {
  final int sampleRate = 8000;
  FlutterSoundPlayer clockPlayer = FlutterSoundPlayer();
  FlutterSoundPlayer recordPlayer = FlutterSoundPlayer();
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
    clockPlayer.openPlayer();
    recordPlayer.openPlayer();
    assetDataInit();
  }

  Future<void> assetDataInit() async {
    final assetFileName = "clock_cut.wav";
    final assetByteData = await rootBundle.load("assets/sounds/$assetFileName");
    assetPath = "${(await getApplicationDocumentsDirectory()).path}/$assetFileName";
    final assetFile = File(assetPath);
    await assetFile.writeAsBytes(assetByteData.buffer.asInt8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes));
    print(assetPath);
  }

  Stream<int> clockPlay() async* {
    int count = 0;
    while (true) {
      int duration = 4 * 1000 * 16 * ref.watch(countProvider) ~/ sampleRate;
      await Future.delayed(Duration(milliseconds: duration));
      if (ref.watch(clockFlagProvider)) {
        await clockPlayer.startPlayer(
          fromURI: assetPath
        );
      }
      count++;
      yield count;
    }
  }

  @override
  void dispose() {
    super.dispose();
    clockPlayer.closePlayer();
    recordPlayer.closePlayer();
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

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
                  Text("ファイル名: ${ref.watch(fileNameProvider)}"),
                  ElevatedButton(
                    child: const Text("ファイルを選択"),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['wav']
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
                  StreamBuilder(
                    stream: clockPlay(),
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return ElevatedButton(
                        child: ref.watch(clockFlagProvider)
                        ? Text("クロックを止める")
                        : Text("クロックを演奏する"),
                        style: styleColorToggle(ref.watch(clockFlagProvider)),
                        onPressed: () async {
                          ref.watch(clockFlagProvider.notifier).switching();
                        },
                      );
                    }
                  ),
                  ElevatedButton(
                    child: ref.watch(acappellaFlagProvider)
                    ? const Text("アカペラを止める")
                    : const Text("アカペラを演奏する"),
                    style: styleColorToggle(ref.watch(acappellaFlagProvider)),
                    onPressed: () async { 
                      if (recordPlayer.isStopped && !(ref.watch(acappellaFlagProvider)) && ref.watch(fileNameProvider) != "") {
                        ref.watch(acappellaFlagProvider.notifier).switching();
                        await recordPlayer.startPlayer(
                          fromURI: ref.watch(fileNameProvider),
                          whenFinished: () { 
                            ref.watch(acappellaFlagProvider.notifier).switching();
                            print("stop player!!");
                          }
                        );
                        print("start player!!");
                      } else if (recordPlayer.isPlaying && ref.watch(acappellaFlagProvider)) {
                        ref.watch(acappellaFlagProvider.notifier).switching();
                        await recordPlayer.stopPlayer();
                        print("stop player!!");
                      } else {
                        print("not responding...");
                        if (recordPlayer.isStopped) print("recordPlayer clear");
                        if (ref.watch(acappellaFlagProvider)) print("acapella clear");
                        if (ref.watch(fileNameProvider) != "") { 
                          print("fileName clear");
                        } else {
                          bool? toastFastapiResult = await Fluttertoast.showToast(
                            msg: "file is not exist...",
                          );
                          if (toastFastapiResult!) {
                            print("toast successfully!!");
                          } else {
                            print("failed to toast");
                          }
                        }
                      }
                    }
                  ),
                  ElevatedButton(
                    child: const Text("WAV→MIDI変換する"),
                    
                    onPressed: () async {
                      if (ref.watch(wav2midiDisableFlagProvider)) {
                        null;
                      } else {
                        print("");
                        ref.watch(wav2midiDisableFlagProvider.notifier).switching();

                        if (ref.watch(fileNameProvider) == "") {
                          print("fileNameProvider is empty text");
                          bool? toastFileExistResult = await Fluttertoast.showToast(
                            msg: "file is not exist...",
                          );
                          if (toastFileExistResult!) {
                            print("toast successfully!!");
                          } else {
                            print("failed to toast");
                          }
                          return;
                        }
                        final formData = FormData.fromMap({
                          'hop_length': 16 * ref.watch(countProvider),
                          'file': await MultipartFile.fromFile(
                            ref.watch(fileNameProvider),
                            filename: ref.watch(fileNameProvider).split("/").last,
                            contentType: MediaType.parse("audio/wav")
                          )
                        });
                        
                        // final response = await dio.get("https://hanauta-7xlrbzh3ba-an.a.run.app/");
                        final response = await dio.post("https://hanauta-7xlrbzh3ba-an.a.run.app/", data: formData);
                        
                        ref.watch(wav2midiDisableFlagProvider.notifier).switching();

                        String message = "";
                        if (response.data.toString() == "{'your_id': 'failed to load file'}") {
                          message = "failed to load file";
                        } else {
                          Directory? rootDirectory = await getExternalStorageDirectory();
                          if (rootDirectory != null) {
                            String saveDirectoryPath = rootDirectory.path + "/Hanauta";
                            Directory saveDirectory = Directory(saveDirectoryPath);
                            await saveDirectory.create(recursive: true);
                            String saveFilePath = saveDirectoryPath + "/save.mid";
                            final saveFile = File(saveFilePath);
                            await saveFile.writeAsBytes(response.data);
                            message = "save file!!";
                          } else {
                            message = "cannot save file...";
                          }
                        }
                        bool? toastFastapiResult = await Fluttertoast.showToast(
                          msg: message,
                        );
                        if (toastFastapiResult!) {
                          print("toast successfully!!");
                        } else {
                          print("failed to toast");
                        }
                      }    
                    }
                  ),
                ]
              )
            )
          ],
        ),
      )
    );
  }
}
