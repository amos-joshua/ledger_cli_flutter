import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class LedgerEntryList extends StatefulWidget {
  final List<Entry> entries;
  const LedgerEntryList({required this.entries, super.key});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<LedgerEntryList> {
  static const dateFormatter = LedgerDateFormatter();

  String entryTitle(Entry entry) {
    final date = dateFormatter.format(entry.date);
    final code = entry.code.isEmpty ? '' : '(${entry.code}) ';
    final state =  entry.state == EntryState.uncleared ? '' : ' ${entry.state.symbolString()} ';
    return "$date $code$state${entry.payee}";
  }

  String entrySubtitle(Entry entry) {
    return entry.postings.map((posting) => '${posting.account}                ${posting.amount}${posting.currency}').join("\n");
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: widget.entries.length,
    itemBuilder: (context, entryIndex) {
      final entry = widget.entries[entryIndex];
      return ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: const Icon(Icons.monetization_on),
        title: Text(entryTitle(entry)),
        subtitle: Text(entrySubtitle(entry))
      );
    }
  );

}