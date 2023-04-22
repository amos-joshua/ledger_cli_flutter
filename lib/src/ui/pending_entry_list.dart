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
        final fontWeight = pendingEntry.processed ? FontWeight.normal : FontWeight.bold;
        final decoration = pendingEntry.markedForDeletion ? TextDecoration.lineThrough : TextDecoration.none;
        final possibleAccounts = widget.accountManager.accounts.values.map((account) => account.name).toList(growable: false);
        return GestureDetector(
          onTap: () {
            AccountSelectionDialog.show(context,
              possibleAccounts: possibleAccounts,
              title: 'Account for',
              message: pendingEntry.csvLine.description
            ).then((newDestinationAccount) {
              if (newDestinationAccount == null) return;
              setState(() {
                pendingEntry.updateDestinationAccount(newDestinationAccount);
              });
            });
          },
          child:  ListTile(
            tileColor: entryIndex.isEven ? Colors.white : Colors.grey[200],
            contentPadding: const EdgeInsets.all(8.0),
            title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Text(entryTitle(pendingEntry), style:  TextStyle(fontFamily: 'monospace', fontWeight: fontWeight, decoration: decoration), textScaleFactor: 1.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ),
                  QueryBadge(label: Text(pendingEntry.destinationAccount.isEmpty ? '?' : pendingEntry.destinationAccount), backgroundColor:  const Color.fromARGB(160, 241, 236, 199),),
                  pendingEntry.csvLine.amount < 0 ? const Icon(Icons.arrow_back): const Icon(Icons.arrow_forward),
                  QueryBadge(label: Text(pendingEntry.importAccount.sourceAccount), backgroundColor: const Color.fromARGB(160, 241, 236, 199)),
                ]
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                if (pendingEntry.markedForDeletion) const PopupMenuItem(
                    value: 'restore',
                    child: Text('Restore')
                )
                else const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete')
                )
              ],
              onSelected: (value) {
                setState(() {
                  pendingEntry.toggleMarkForDeletion();
                });
              },
            )
          )
        );
      }
  );

}
