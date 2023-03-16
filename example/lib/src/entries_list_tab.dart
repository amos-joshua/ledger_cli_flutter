import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

class EntriesListTab extends StatefulWidget {
  final LedgerSession ledgerSession;
  const EntriesListTab({required this.ledgerSession, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EntriesListTab> {
  final List<Entry> filteredEntries = [];
  LedgerSession get ledgerSession => widget.ledgerSession;
  QueryExecutor get queryExecutor => widget.ledgerSession.queryExecutor;

  @override
  void initState() {
    super.initState();
    loadEntries();

    ledgerSession.query.addListener(loadEntries);
  }

  @override
  void dispose() {
    ledgerSession.query.removeListener(loadEntries);
    super.dispose();
  }

  loadEntries() {
    Future(() => queryExecutor.queryFilter(ledgerSession.ledger, ledgerSession.query.value)).then((filterResult) {
      final entries = filterResult.matches;
      entries.sort((entry1, entry2) => entry2.date.compareTo(entry1.date));

      setState(() {
        filteredEntries.clear();
        filteredEntries.addAll(entries);
      });
    }).catchError((error, stackTrace) {
      print("Query error: $error \n$stackTrace");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: const QueryEditorBar(

          ),
        ),
        Expanded(
          child: LedgerEntryList(entries: filteredEntries)
        )
      ]
    );
  }

}