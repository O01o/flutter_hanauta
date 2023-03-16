import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveDirectoryPath(String childPath) async {
  Directory? rootDirectory = await getExternalStorageDirectory();
  String hanautaPath = "Hanauta";
  if (rootDirectory != null) {
    String saveDirectoryPath = "${rootDirectory.path}/$hanautaPath/$childPath";
    print(saveDirectoryPath);
    Directory saveDirectory = Directory(saveDirectoryPath);
    await saveDirectory.create(recursive: true);
    return saveDirectoryPath;
  } else {
    return "";
  }
}