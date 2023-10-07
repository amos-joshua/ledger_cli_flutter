import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class ImportAccountDialog {
  final BuildContext context;

  ImportAccountDialog(this.context);

  Future<ImportAccount?> show(List<ImportAccount> importAccounts) {
    return showDialog<ImportAccount>(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
            title: const Text('Import into:'),
            content:_accountsList(importAccounts)
        )
    );
  }

  Widget _accountsList(List<ImportAccount> importAccounts) => Column(
      mainAxisSize: MainAxisSize.min,
      children: importAccounts.map((importAccount) =>
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(importAccount.label),
            subtitle: Text('${importAccount
                .sourceAccount} (${importAccount
                .currency})'),
            onTap: () {
              Navigator.of(context).pop(importAccount);
            },
          )
      ).toList(growable: false),
    );
}