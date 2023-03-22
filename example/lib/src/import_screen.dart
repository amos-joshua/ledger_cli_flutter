import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

class ImportScreen extends StatefulWidget {
  final ImportSession importSession;
  const ImportScreen({required this.importSession, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ImportScreen> {
  ImportSession get importSession => widget.importSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import'),
        actions: [
          ElevatedButton(
            child: Text('Save...'),
            onPressed: () {
              print("DBG saving import!");
            },
          )
        ],
      ),
      body: PendingEntryList(
        pendingEntries: importSession.pendingEntries,
        accountManager: importSession.accountManager
      )
    );
  }

}