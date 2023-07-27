import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:core';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:flutter_hanauta/style.dart';
import 'package:flutter_hanauta/providers/wav2midi_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_hanauta/utils/add_save_path.dart';
import 'package:flutter_hanauta/logic/asset_loader.dart';
import 'package:flutter_hanauta/logic/env_loader.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Wav2MidiScreen extends HookConsumerWidget {
  Wav2MidiScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    int sampleRate = 8000;
    String assetPath = "";
    final dio = Dio();
    final clockPlayer = FlutterSoundPlayer();
    final recordPlayer = FlutterSoundPlayer();

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
    
    useEffect(() {
      clockPlayer.openPlayer();
      recordPlayer.openPlayer();
      envLoader();
      assetLoader(assetPath);

      return () {
        clockPlayer.closePlayer();
        recordPlayer.closePlayer();
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
                  Text(
                    "ファイル名: ${ref.watch(fileNameProvider).split("/").last}",
                    textAlign: TextAlign.center,
                  ),
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
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "♬ length: ${ref.watch(countProvider)}  "),
                        TextSpan(
                          text: "BPM: ${sampleRate*(60/4) / (16*ref.watch(countProvider)) ~/ 0.01 / 100}",
                          style: bigText()
                        )
                      ]
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                        
                        final response = await dio.post(
                          dotenv.env["LINK"]!,
                          data: formData,
                          options: Options(responseType: ResponseType.bytes)
                        );
                        
                        ref.watch(wav2midiDisableFlagProvider.notifier).switching();

                        String message = "";
                        // if (utf8.decode(response.data) == "{'your_id': 'failed to load file'}") {
                        if (false) {
                          message = "failed to load file";
                        } else {
                          String saveFileName = "${ref.watch(fileNameProvider).split("/").last.split(".").first}.mid";
                          // String saveFileName = "aiueo.txt";
                          String saveFilePath = "${await saveDirectoryPath("midi")}/$saveFileName";
                          final saveFile = File(saveFilePath);
                          await saveFile.writeAsBytes(response.data as List<int>);
                          message = "save file!!";
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
