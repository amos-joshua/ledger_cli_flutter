import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class BalanceTable extends StatefulWidget {
  final BalanceResult balanceResult;
  final void Function(String)? onDoubleTap;
  final List<Widget> Function(BuildContext, String)? actionsBuilder;
  const BalanceTable({required this.balanceResult, this.onDoubleTap, this.actionsBuilder, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BalanceTable> {
  late final List<String> accounts;
  String? selectedAccount;

  @override
  void initState() {
    super.initState();
    accounts = widget.balanceResult.balances.map((balanceEntry) => balanceEntry.account).toList(growable: false);
  }

  String titleForAccount(String account) {
    final balanceEntry = widget.balanceResult.balances.firstWhere((entry) => entry.account == account, orElse: () => BalanceEntry(account: account, denominatedAmount: DenominatedAmount(0, '')));
    if (balanceEntry.denominatedAmount.currency.isEmpty) return '$account: 0';
    return '$account: ${balanceEntry.denominatedAmount}';
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
    final actionsBuilder = widget.actionsBuilder;
    return TableRow(
        decoration: BoxDecoration(
            color: selectedAccount == account ? Colors.blue.withAlpha(96) : index.isEven ? Colors.grey[200] : Colors.white70
        ),
        children: [
          pad(8, Text(account, style: textStyle)),
          pad(8, Align(alignment: Alignment.centerRight, child: Text(widget.balanceResult.balances[index].denominatedAmount.toString(),  style: textStyle))),
          if (actionsBuilder == null) const Text('')
          else Row(
            mainAxisSize: MainAxisSize.min,
            children: actionsBuilder(context, account)
          )
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