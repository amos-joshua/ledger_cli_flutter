import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dialogs/dialogs.dart';
import 'model/model.dart';
import 'controller/app_controller.dart';

class SelectAFileScreen extends StatelessWidget {
  const SelectAFileScreen({super.key});

  void onSelectFileTapped(BuildContext context) {
    final appController = context.read<AppController>();
    final preferences = context.read<AppModel>().ledgerPreferences;
    SelectLedgerFileDialog(context).show(initialDirectory: File(preferences.defaultLedgerFile).parent.path).then((source) {
      if (source != null) {
        appController.loadLedger(source);
      }
    });
    /*
    FilePicker.platform.pickFiles(initialDirectory: File(preferences.defaultLedgerFile).parent.path).then((result) {
      if (result == null) return;
      final ledgerPath = result.files.single.path;
      if (ledgerPath == null) {
        AlertMessageDialog(context).show(title: 'Error loading file', message: 'path is empty');
        return;
      }
      final source = LedgerSource.forFile(ledgerPath);
      appController.loadLedger(source);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () => onSelectFileTapped(context),
          child: const Text('Select ledger file...')
        )
    );
  }

}