import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> envLoader() async {
  await dotenv.load();
}