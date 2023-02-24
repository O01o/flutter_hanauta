import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StreamProvider.autoDispose((ref) async* {
  while (true) {
    await Future.delayed(const Duration(microseconds: 1000000));
    
  }
});