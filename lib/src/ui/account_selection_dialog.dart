import 'package:flutter/material.dart';
import 'query_editor_bar/text_field_delay.dart';

class AccountSelectionDialog extends StatefulWidget {
  final List<String> possibleAccounts;
  final String title;
  final String message;
  const AccountSelectionDialog({super.key, required this.possibleAccounts, required this.title, required this.message});
  
  @override
  State<StatefulWidget> createState() => _State();

  static Future<String?> show(BuildContext context, {required List<String> possibleAccounts, String title = 'Account', String message = ''}) {
    return showDialog<String>(
        context: context,
        builder: (dialogContext) => AccountSelectionDialog(possibleAccounts: possibleAccounts, title: title, message: message)
    );
  }
}

class _State extends State<AccountSelectionDialog> {
  final filterEditingController = TextEditingController();
  final filterFocusNode = FocusNode();
  String selectedAccount = '';
  String filter = '';

  late final textFieldDelay = TextFieldDelay(onChange: updateFilter);

  List<String> filteredAccounts() => widget.possibleAccounts.where((account) => account.toLowerCase().contains(filter)).toList(growable: false);

  String firstFilterMatch() => widget.possibleAccounts.firstWhere((account) => account.toLowerCase().contains(filter), orElse: () => '');

  @override
  void initState() {
    super.initState();
  }

  void updateFilter(String newFilter) {
    setState((){
      filter = newFilter.toLowerCase();
      selectedAccount = filter.isEmpty ? '' : firstFilterMatch();
    });
  }

  Widget accountList() => ListBody(
    children: filteredAccounts().map((account) =>
      ListTile(
        dense: true,
        selected: selectedAccount == account,
        title: Text(account),
        onTap: () {
          Navigator.of(context).pop(account);
        },
      )).toList()
  );

  @override
  Widget build(BuildContext context) {
    filterFocusNode.requestFocus();
    return AlertDialog(
        title: Text(widget.title),
        content: Column(
          children: [
            if (widget.message.isNotEmpty) Text(widget.message, style: const TextStyle(fontFamily: 'monospace')),
            TextField(
              controller: filterEditingController,
              onChanged: (newValue) => textFieldDelay.updateValue(newValue),
              focusNode: filterFocusNode,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: accountList()
              )
            )
          ]
        ),
        actions: [
          ElevatedButton(onPressed: (){ Navigator.of(context).pop(null); }, child: const Text('Cancel')),
          ElevatedButton(onPressed: selectedAccount.isEmpty ? null : (){ Navigator.of(context).pop(selectedAccount); }, child: const Text('Ok'))
        ],
    );
  }
  
}



