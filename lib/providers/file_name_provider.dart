import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

final fileNameProvider = StateProvider<String>((ref) => "no file...");