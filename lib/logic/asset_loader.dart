import 'package:flutter/services.dart';
import 'dart:core';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> assetLoader(String assetPath) async {
  String assetFileName = "clock_cut.wav";
  final assetByteData = await rootBundle.load("assets/sounds/$assetFileName");
  assetPath = "${(await getApplicationDocumentsDirectory()).path}/$assetFileName";
  final assetFile = File(assetPath);
  await assetFile.writeAsBytes(assetByteData.buffer.asInt8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes));
  print(assetPath);
}