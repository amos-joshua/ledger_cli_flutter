import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'model/model.dart';

class EntriesListTab extends StatefulWidget {
  final Query query;
  const EntriesListTab({required this.query, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EntriesListTab> {
  static const queryExecutor = QueryExecutor();
  final List<Entry> filteredEntries = [];
  late final Ledger ledger;
  late final ValueNotifier<Query> query = ValueNotifier(widget.query);

  @override
  void initState() {
    super.initState();
    ledger = context.read<AppModel>().ledger;
    loadEntries();

    query.addListener(loadEntries);
  }

  @override
  void dispose() {
    query.removeListener(loadEntries);
    super.dispose();
  }

  loadEntries() {
    Future(() => queryExecutor.queryFilter(ledger, query.value)).then((filterResult) {
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
          child: QueryEditorBar(
            query: query,
            ledger: ledger
          )
        ),
        Expanded(
          child: LedgerEntryList(entries: filteredEntries)
        )
      ]
    );
  }

}