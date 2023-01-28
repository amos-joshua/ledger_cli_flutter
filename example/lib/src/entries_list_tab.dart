import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

class EntriesListTab extends StatefulWidget {

  const EntriesListTab({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EntriesListTab> {
  late LedgerSession ledgerSession;

  @override
  void initState() {
    super.initState();
    ledgerSession = LedgerSession.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return LedgerEntryList(entries: ledgerSession.ledger.entries);
  }

}