import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

class EntriesListScreen extends StatefulWidget {
  final String ledgerPath;

  const EntriesListScreen({required this.ledgerPath, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EntriesListScreen> {
  static const ledgerFileLoader = LedgerFileLoader();
  Ledger? ledger;

  @override
  void initState() {
    super.initState();
    ledgerFileLoader.load(widget.ledgerPath, onApplyFailure: (edit, exc, stackTrace) {
      print("ERROR: could not apply $edit: $exc\n$stackTrace");
    }).then((newLedger) {
      setState(() {
        ledger = newLedger;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ledger = this.ledger;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ledger')
      ),
      body: ledger == null ?
        const Center (
          child: CircularProgressIndicator(),
        ) :
        LedgerEntryList(
          entries: ledger.entries,
        )
    );
  }

}