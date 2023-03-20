import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'balances_screen.dart';
import 'error_dialog.dart';

class SelectAFileScreen extends StatefulWidget {
  const SelectAFileScreen({super.key});

  @override
  State createState() => _State();
}

class _State extends State<SelectAFileScreen> {
  late final LedgerPreferences ledgerPreferences;
  var didLoad = false;

  @override
  void initState() {
    super.initState();
    ledgerPreferences = LedgerPreferencesContainer.preferencesOf(context);
    tryLoadDefaultLedger();
  }

  void tryLoadDefaultLedger() async {
    final defaultLedgerPath = ledgerPreferences.defaultLedgerFile;
    // NOTE: flutter doesn't like pushing a route from the initState, so delay
    // a better solution would be to use more sophisticated routing
    Future.delayed(const Duration(milliseconds: 50), ()
    {
      final defaultLedgerFile = File(defaultLedgerPath);
      if (defaultLedgerFile.existsSync()) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            BalancesScreen(ledgerPath: defaultLedgerPath,
                ledgerPreferences: ledgerPreferences))).then((value) {
          setState(() {
            didLoad = true;
          });
        });
      }
      else {
        ErrorDialog(context).show('Oops', 'Could not load ledger file $defaultLedgerPath, file does not exist');
        setState(() {
          didLoad = true;
        });
      }
    });
  }

  void onSelectFileTapped(BuildContext context) {
    FilePicker.platform.pickFiles(initialDirectory: Directory.current.path).then((result) {
      if (result == null) return;
      final ledgerPath = result.files.single.path;
      if (ledgerPath == null) {
        print("ERROR: select returned null path");
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BalancesScreen(ledgerPath: ledgerPath, ledgerPreferences: ledgerPreferences)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger CLI Explorer')
      ),
     body:Center(
        child: didLoad ? ElevatedButton(
          onPressed: () => onSelectFileTapped(context),
          child: const Text('Select ledger file...')
        ) : const Center(
          child: SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          )
        )
      )
    );
  }

}