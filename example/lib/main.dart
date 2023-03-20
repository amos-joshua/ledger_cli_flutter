import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'src/select_a_file_screen.dart';
import 'src/error_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ledger CLI Explorer',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: LedgerPreferencesContainer(
        ledgerPreferencesPath: 'ledger-preferences.json',
        onError: (errorMessage) => ErrorDialog(context).show('Oops', errorMessage),
        child:  const SelectAFileScreen()
      )
    );
  }
}
