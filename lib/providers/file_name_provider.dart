import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileNameProvider = StateProvider.autoDispose<String>((ref) => "");