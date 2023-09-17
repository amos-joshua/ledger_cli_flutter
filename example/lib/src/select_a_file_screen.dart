import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ledger_cli/ledger_cli.dart';

import 'dialogs/alert.dart';
import 'providers.dart';

class SelectAFileScreen extends ConsumerWidget {
  const SelectAFileScreen({super.key});

  void onSelectFileTapped(BuildContext context, WidgetRef ref) {
    FilePicker.platform.pickFiles(initialDirectory: Directory.current.path).then((result) {
      if (result == null) return;
      final ledgerPath = result.files.single.path;
      if (ledgerPath == null) {
        AlertMessageDialog(context).show(title: 'Error loading file', message: 'path is empty');
        return;
      }
      final source = LedgerSource.forFile(ledgerPath);
      ref.read(providers.appController).loadLedger(source);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: ElevatedButton(
          onPressed: () => onSelectFileTapped(context, ref),
          child: const Text('Select ledger file...')
        )
    );
  }

}