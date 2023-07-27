import 'package:flutter/material.dart';

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_hanauta/utils/add_save_path.dart';

class FileSaveDialog extends HookConsumerWidget {
  const FileSaveDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("ファイルを保存しますか？"),
      content: const Text("aiueo tmp message"),
      actions: [
        TextButton(
          child: const Text("やめる"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("保存する"),
          onPressed: () async {
            String childPath = "wav";
            String saveFileName = "record.wav";
            String saveFilePath = "${await saveDirectoryPath(childPath)}/$saveFileName";
            final saveFile = File(saveFilePath);
            // await saveFile.writeAsBytes();
          }
        )
      ],
    );
  }
}