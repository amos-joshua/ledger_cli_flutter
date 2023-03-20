import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class PendingEntryList extends StatefulWidget {
  final List<PendingImportedEntry> pendingEntries;
  const PendingEntryList({required this.pendingEntries, super.key});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<PendingEntryList> {
  static const dateFormatter = LedgerDateFormatter();

  String entryTitle(PendingImportedEntry pendingEntry) {
    final date = dateFormatter.format(pendingEntry.csvLine.date);
    return "$date ${pendingEntry.csvLine.description}";
  }

  String entryTrailing(PendingImportedEntry pendingEntry) {
    final amountSign = pendingEntry.csvLine.amount >= 0 ? '+' : '';
    return '$amountSign${pendingEntry.csvLine.amount} ${pendingEntry.importAccount.currency}';
  }

  String entrySubtitle(PendingImportedEntry pendingEntry) {
    return '${pendingEntry.importAccount.sourceAccount} -> ${pendingEntry.destinationAccount.isEmpty ? '?' : pendingEntry.destinationAccount}';
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: widget.pendingEntries.length,
      itemBuilder: (context, entryIndex) {
        final entry = widget.pendingEntries[entryIndex];
        return ListTile(
            tileColor: entryIndex.isEven ? Colors.white : Colors.grey[200],
            contentPadding: const EdgeInsets.all(8.0),
            leading: const Icon(Icons.sync_alt),
            title: Text(entryTitle(entry), style: const TextStyle(fontFamily: 'monospace'), textScaleFactor: 0.9),
            trailing: Text(entryTrailing(entry), style: const TextStyle(fontFamily: 'monospace'), textScaleFactor: 0.9),
            subtitle: Text(entrySubtitle(entry), style: const TextStyle(fontFamily: 'monospace'))
        );
      }
  );

}