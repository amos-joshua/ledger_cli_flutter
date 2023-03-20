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

  String postingLine(Posting posting) {
    final accountPadding = posting.amount < 0 ? 49 : 50;
    final amountPadding = posting.amount < 0 ? 11 : 10;
    return '${posting.account.padRight(accountPadding)}${posting.amount.toStringAsFixed(2).padLeft(amountPadding)} ${posting.currency}';
  }

  String entrySubtitle(Entry entry) {
    return entry.postings.map((posting) => postingLine(posting)).join("\n");
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: widget.entries.length,
    itemBuilder: (context, entryIndex) {
      final entry = widget.entries[entryIndex];
      return ListTile(
        tileColor: entryIndex.isEven ? Colors.white : Colors.grey[200],
        contentPadding: const EdgeInsets.all(8.0),
        leading: const Icon(Icons.sync_alt),
        title: Text(entryTitle(entry)),
        subtitle: Text(entrySubtitle(entry), style: const TextStyle(fontFamily: 'monospace'))
      );
    }
  );

}