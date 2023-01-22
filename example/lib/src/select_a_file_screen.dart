import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'entries_list_screen.dart';

class SelectAFileScreen extends StatelessWidget {
  const SelectAFileScreen({super.key});

  void onSelectFileTapped(BuildContext context) {
    FilePicker.platform.pickFiles(initialDirectory: Directory.current.path).then((result) {
      if (result == null) return;
      final ledgerPath = result.files.single.path;
      if (ledgerPath == null) {
        print("ERROR: select returned null path");
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EntriesListScreen(ledgerPath: ledgerPath)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger CLI Explorer')
      ),
     body: Center(
      child: ElevatedButton(
        onPressed: () => onSelectFileTapped(context),
        child: const Text('Select ledger file...')
      )
    )
    );
  }

}