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
  Widget build(BuildContext context) => SingleChildScrollView(child: DataTable(
    columns: const [
      DataColumn(label: Text('Account')),
      DataColumn(label: Text('Balance')),
    ],
    rows: List<DataRow>.generate(
      accounts.length,
          (index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>((states) => colorForState(states, index)),
            cells: <DataCell>[
              DataCell(Text(accounts[index], style:const TextStyle(fontFamily: 'monospace'))),
              DataCell(Align(alignment: Alignment.centerRight, child: Text(widget.balanceResult.balances[accounts[index]]?.toString() ?? '',  style:const TextStyle(fontFamily: 'monospace'))), ),
            ],
            selected: false,
          ),
    )));
}