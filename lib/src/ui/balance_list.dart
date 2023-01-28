import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class BalanceList extends StatefulWidget {
  final BalanceResult balanceResult;
  const BalanceList({required this.balanceResult, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BalanceList> {
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

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, entryIndex) {
        final account = accounts[entryIndex];
        return ListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          title: Text(titleForAccount(account), style: const TextStyle(fontFamily: 'monospace')),
        );
      }
  );

}