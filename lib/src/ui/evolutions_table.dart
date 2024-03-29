import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ledger_cli/ledger_cli.dart';

class EvolutionsTable extends StatefulWidget {
  final BalanceResult balanceResult;
  final List<Widget> Function(BuildContext, String, DateRange?)? actionsBuilder;
  const EvolutionsTable({required this.balanceResult, this.actionsBuilder, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EvolutionsTable> {
  static final amountFormatter = NumberFormat('###,###.00', 'en_US"');
  late final List<String> accounts;

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

  Widget pad(double padding, Widget child) => Padding(padding: EdgeInsets.all(padding), child: child);

  TableRow tableRowForAccount(int index, String account) {
    const textStyle = TextStyle(fontFamily: 'monospace', /*fontWeight: selectedAccount == account ? FontWeight.bold : null*/);
    final balanceEntry = widget.balanceResult.balances[index];
    final amountString = amountFormatter.format(balanceEntry.denominatedAmount.amount);
    final amountCurrency = balanceEntry.denominatedAmount.currency;
    final amountSign = balanceEntry.denominatedAmount.amount > 0 ? '+' : '';
    final actionsBuilder = widget.actionsBuilder;
    return TableRow(
        decoration: BoxDecoration(
            color: index.isEven ? Colors.grey[200] : Colors.white70
        ),
        children: [
          pad(8, Text(balanceEntry.period?.prettyPrint() ?? '')),
          pad(8, Text(account, style: textStyle)),
          pad(8, Align(alignment: Alignment.centerRight, child: Text('$amountSign$amountString $amountCurrency',  style: textStyle))),
          if (actionsBuilder == null) const Text('')
          else Row(
              mainAxisSize: MainAxisSize.min,
              children: actionsBuilder(context, account, balanceEntry.period?.dateRange)
          )
        ].toList(growable: false)
    );
  }

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold);

    return SingleChildScrollView(child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
          3: FlexColumnWidth(1)
        },
        children: [
          TableRow(
              children: ['Date(s)', 'Account', 'Amount', ''].map((header) =>  pad(8, Align(alignment: Alignment.center, child: Text(header, style: headerStyle)))).toList(growable: false)
          ),
          ... accounts.asMap().map((index, account) => MapEntry(index, tableRowForAccount(index, account))
          ).values
        ]
    )
    );
  }
}