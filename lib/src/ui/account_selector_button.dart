import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import '../ledger_session/ledger_session.dart';
import 'account_selection_dialog.dart';

class AccountSelectorButton extends StatefulWidget {
  final LedgerSession ledgerSession;

  const AccountSelectorButton({required this.ledgerSession, super.key});

  @override
  State createState() => _State();
}


class _State extends State<AccountSelectorButton> {

  List<String> possibleAccounts() {
    final possibleAccounts = <String>[];
    final sortedAccounts = widget.ledgerSession.ledger.accountManager.accounts.keys.toList(growable: false);
    sortedAccounts.sort();
    for (final account in sortedAccounts) {
      final accountComponents = account.split(':');
      var nextAccount = "";
      for (final component in accountComponents) {
        nextAccount = "$nextAccount${nextAccount.isEmpty ? '' : ':'}$component";
        if (!possibleAccounts.contains(nextAccount)) {
          possibleAccounts.add(nextAccount);
        }
      }
    }
    return possibleAccounts;
  }

  void showSelectDialog() {
    showDialog<List<String>>(
        context: context,
        builder: (dialogContext) => AccountSelectionDialog(
            possibleAccounts: possibleAccounts(),
            initiallySelected: widget.ledgerSession.query.value.accounts
        )
    ).then((newAccounts) {
      if (newAccounts == null) return;
      setState(() {
        widget.ledgerSession.query.value = widget.ledgerSession.query.value.modify(accounts: newAccounts);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryAccounts = widget.ledgerSession.query.value.accounts;
    return ElevatedButton(
        onPressed: showSelectDialog,
        child: Text(queryAccounts.isEmpty ? 'All accounts' : queryAccounts.length == 1 ? queryAccounts.first : '${queryAccounts.length} accounts')
    );
  }
}