import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'import_starter.dart';

class ImportScreen extends StatefulWidget {
  final ImportSession importSession;
  final LedgerPreferences ledgerPreferences;
  const ImportScreen({required this.importSession, required this.ledgerPreferences, super.key});

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
            child: const Text('Add...'),
            onPressed: () {
              final importStarter = ImportStarter();
              importStarter.startImport(
                  context,
                  ledgerPreferences: widget.ledgerPreferences,
                  accountManager: importSession.accountManager,
                  ongoingImportSession: importSession
              ).then((importSession) {
                if (importSession == null) return;
                setState((){});
              });
            },
          ),
          ElevatedButton(
            child: const Text('Save...'),
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