import 'package:permission_handler/permission_handler.dart';

void recorderInit() async {
  final microphoneStatus = await Permission.microphone.request();
  if (microphoneStatus != PermissionStatus.granted) {
    throw 'Microphone permission not granted';
  }
  
  final cameraStatus = await Permission.camera.request();
  if (cameraStatus != PermissionStatus.granted) {
    throw 'Camera permission not granted';
  }
  
  final storageStatus = await Permission.storage.request();
  if (storageStatus != PermissionStatus.granted) {
    throw 'Storage permission not granted';
  }
}