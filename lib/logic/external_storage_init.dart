import 'package:permission_handler/permission_handler.dart';

Future<void> externalStorageInit() async {
  final storageStatus = await Permission.storage.request();
  if (storageStatus != PermissionStatus.granted) {
    throw 'Storage permission not granted';
  }
}