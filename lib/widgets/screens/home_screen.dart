import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ElevatedButton(
                    child: const Text("録音する"),
                    onPressed: () => Navigator.pushNamed(context, "/recording")
                  ),
                  ElevatedButton(
                    child: const Text("WAV→MIDIに変換する"),
                    onPressed: () => Navigator.pushNamed(context, "/wav2midi")
                  ),
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}