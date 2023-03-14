import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// final filePathProvider = FutureProvider<Directory>((ref) => getApplicationDocumentsDirectory());
// final saveFilePathProvider = FutureProvider<Directory?>((ref) => getExternalStorageDirectory());

final assetPathProvider = FutureProvider<String>((ref) => rootBundle.loadString("assets/sounds/clock_cut.wav"));