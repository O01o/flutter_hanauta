import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hanauta/providers/file_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: CustomScrollView(
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
                )
              ]
            )
          )
        ],
      )
    );
  }
}