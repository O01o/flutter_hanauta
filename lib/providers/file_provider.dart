import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

final fileProvider = StateProvider<File>((ref) => File("./assets/sounds/clock_cut.wav"));