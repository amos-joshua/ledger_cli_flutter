import 'package:flutter/material.dart';


class AccountSelectionDialog extends StatefulWidget {
  final List<String> possibleAccounts;
  final List<String> initiallySelected;

  const AccountSelectionDialog({super.key, required this.possibleAccounts, required this.initiallySelected});
  
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AccountSelectionDialog> {
  final List<String> selectedAccounts = [];

  @override
  void initState() {
    super.initState();
    selectedAccounts.addAll(widget.initiallySelected);
  }
  
  String selectedCount() {
    return selectedAccounts.isEmpty ? '' : ' (${selectedAccounts.length} selected)';
  }


  Widget accountCheckboxList() => SingleChildScrollView(
    child: ListBody(
      children: widget.possibleAccounts.map((account) =>
        CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value:selectedAccounts.contains(account),
            title: Text(account),
            onChanged: (newValue) {
              setState(() {
                if (newValue == true) {
                  selectedAccounts.add(account);
                }
                else {
                  selectedAccounts.remove(account);
                }
              });
            }
        )).toList())
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title:  Text('Accounts${selectedCount()}'),
        content:  accountCheckboxList(),
        actions: [
          ElevatedButton(onPressed: (){ Navigator.of(context).pop(null); }, child: const Text('Cancel')),
          ElevatedButton(onPressed: (){ Navigator.of(context).pop(selectedAccounts); }, child: const Text('Ok'))
        ],
    );
  }
  
}



