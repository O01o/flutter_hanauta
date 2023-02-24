import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordingScreen extends ConsumerWidget {
  const RecordingScreen({Key? key, required this.title}) : super(key: key);

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
                  onPressed: () => Navigator.pushNamed(context, "")
                ),

              ]
            )
          )
        ],
      )
    );
  }
}