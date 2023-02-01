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
  final List<Entry> filteredEntries = [];

  @override
  void initState() {
    super.initState();
    ledgerSession = LedgerSession.of(context);
    loadEntries();

    ledgerSession.query.addListener(loadEntries);
  }

  @override
  void dispose() {
    ledgerSession.query.removeListener(loadEntries);
    super.dispose();
  }

  loadEntries() {
    Future(() => ledgerSession.queryExecutor.queryFilter(ledgerSession.ledger, ledgerSession.query.value)).then((filterResult) {
      setState(() {
        filteredEntries.clear();
        filteredEntries.addAll(filterResult.matches.map((invertedPosting) => invertedPosting.parent).toList(growable: false));
      });
    }).catchError((error, stackTrace) {
      print("Query error: $error \n$stackTrace");
    });
  }

  @override
  Widget build(BuildContext context) {
    return LedgerEntryList(entries: filteredEntries);
  }

}