import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'account_selection_dialog.dart';
import 'query_editor_bar/query_badge.dart';

class PendingEntryList extends StatefulWidget {
  final List<PendingImportedEntry> pendingEntries;
  final AccountManager accountManager;
  const PendingEntryList({required this.pendingEntries, required this.accountManager, super.key});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<PendingEntryList> {
  static const dateFormatter = LedgerDateFormatter();

  /*
  String entryTitle(PendingImportedEntry pendingEntry) {
    final date = dateFormatter.format(pendingEntry.csvLine.date);
    return "$date ${pendingEntry.csvLine.description}";
  }*/

  String entryTitle(PendingImportedEntry pendingEntry) {
    final date = dateFormatter.format(pendingEntry.csvLine.date);

    final amountSign = pendingEntry.csvLine.amount >= 0 ? '+' : '';
    final amount = '$amountSign${pendingEntry.csvLine.amount} ${pendingEntry.importAccount.currency}'.padLeft(12, ' ');

    return "$date  $amount    ${pendingEntry.csvLine.description}";
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
        final pendingEntry = widget.pendingEntries[entryIndex];
        final fontWeight = pendingEntry.touched ? FontWeight.normal : FontWeight.bold;
        return GestureDetector(
          onDoubleTap: () {
            AccountSelectionDialog.show(context, possibleAccounts: widget.accountManager.accounts.values.map((account) => account.name).toList(growable: false)).then((newDestinationAccount) {
              if (newDestinationAccount == null) return;
              setState(() {
                pendingEntry.updateDestinationAccount(newDestinationAccount);
              });
            });
          },
          child: ListTile(
            tileColor: entryIndex.isEven ? Colors.white : Colors.grey[200],
            contentPadding: const EdgeInsets.all(8.0),
            title: Container(
              width: double.infinity,
              child: Text(entryTitle(pendingEntry), style:  TextStyle(fontFamily: 'monospace', fontWeight: fontWeight), textScaleFactor: 1.0,
              overflow: TextOverflow.ellipsis,
            ),
            ),
            //trailing: Text(entryTrailing(pendingEntry), style:  TextStyle(fontFamily: 'monospace', fontWeight: fontWeight), textScaleFactor: 1.0),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                QueryBadge(label: Text(pendingEntry.importAccount.sourceAccount), backgroundColor: Color.fromARGB(160, 241, 236, 199)),
                const Text(' -> '),
                if (pendingEntry.destinationAccount.isNotEmpty) QueryBadge(label: Text(pendingEntry.destinationAccount), backgroundColor:  Color.fromARGB(160, 241, 236, 199),),

              ]
            ),
            //subtitle: Text(entrySubtitle(pendingEntry), style: TextStyle(fontFamily: 'monospace', fontWeight: fontWeight)),
          )
        );
      }
  );

}