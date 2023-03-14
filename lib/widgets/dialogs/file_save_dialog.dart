import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class FileSaveDialog extends ConsumerWidget {
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
          onPressed: () {

          }
        )
      ],
    );
  }
}