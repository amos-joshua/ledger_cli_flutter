import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class BalanceTable extends StatefulWidget {
  final BalanceResult balanceResult;
  const BalanceTable({required this.balanceResult, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BalanceTable> {
  late final List<String> accounts;

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

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold);

    Widget pad(double padding, Widget child) => Padding(padding: EdgeInsets.all(padding), child: child);

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
          ... accounts.asMap().map((index, account) => MapEntry(index, TableRow(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.grey[200] : Colors.white70
            ),
              children: [
                pad(8, Text(account, style:const TextStyle(fontFamily: 'monospace'))),
                pad(8, Align(alignment: Alignment.centerRight, child: Text(widget.balanceResult.balances[account]?.toString() ?? '',  style:const TextStyle(fontFamily: 'monospace')))),
                const Text('')
              ]
          ))
          ).values

        ]
    )
    );
  }
}