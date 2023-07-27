import 'package:flutter/services.dart';

import 'dart:core';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> assetLoader(String assetPath) async {
  final assetFileName = "clock_cut.wav";
  final assetByteData = await rootBundle.load("assets/sounds/$assetFileName");
  assetPath = "${(await getApplicationDocumentsDirectory()).path}/$assetFileName";
  final assetFile = File(assetPath);
  await assetFile.writeAsBytes(assetByteData.buffer.asInt8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes));
  print(assetPath);
}