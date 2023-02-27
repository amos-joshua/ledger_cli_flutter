import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class BalanceTable extends StatefulWidget {
  final BalanceResult balanceResult;
  final void Function(String)? onDoubleTap;
  const BalanceTable({required this.balanceResult, this.onDoubleTap, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BalanceTable> {
  late final List<String> accounts;
  String? selectedAccount;

  @override
  void initState() {
    super.initState();
    accounts = widget.balanceResult.balances.keys.toList(growable: false);
  }

  String titleForAccount(String account) {
    final denominatedAmount = widget.balanceResult.balances[account];
    if (denominatedAmount == null) return '$account: 0';
    return '$account: $denominatedAmount';
  }

  Color? colorForState(Set<MaterialState> states, int index) {
    if (states.contains(MaterialState.selected)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }
    if (index.isEven) {
      return Colors.grey.withOpacity(0.3);
    }
    return null;
  }

  Widget pad(double padding, Widget child) => Padding(padding: EdgeInsets.all(padding), child: child);

  TableRow tableRowForAccount(int index, String account) {
    const textStyle = TextStyle(fontFamily: 'monospace', /*fontWeight: selectedAccount == account ? FontWeight.bold : null*/);
    final doubleTapCallback = widget.onDoubleTap;
    return TableRow(
        decoration: BoxDecoration(
            color: selectedAccount == account ? Colors.blue.withAlpha(96) : index.isEven ? Colors.grey[200] : Colors.white70
        ),
        children: [
          pad(8, Text(account, style: textStyle)),
          pad(8, Align(alignment: Alignment.centerRight, child: Text(widget.balanceResult.balances[account]?.toString() ?? '',  style: textStyle))),
          const Text('')
        ].map((child) => GestureDetector(
          onDoubleTap: doubleTapCallback == null ? (){} : () => doubleTapCallback(account),
          onTap: () {
            setState(() {
              selectedAccount = selectedAccount == account ? null : account;
            });
          },
          child: child,
        )).toList(growable: false)
    );
  }

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold);


    return SingleChildScrollView(child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          3: FlexColumnWidth(1)
        },
        children: [
           TableRow(
              children: ['Account', 'Balance', ''].map((header) =>  pad(8, Align(alignment: Alignment.center, child: Text(header, style: headerStyle)))).toList(growable: false)
          ),
          ... accounts.asMap().map((index, account) => MapEntry(index, tableRowForAccount(index, account))
          ).values

        ]
    )
    );
  }
}