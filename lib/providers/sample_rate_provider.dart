import 'package:flutter_riverpod/flutter_riverpod.dart';

final countProvider = StateProvider.autoDispose<int>((ref) => 100);