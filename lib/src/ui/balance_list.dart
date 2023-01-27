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

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: widget.balanceResult.balances.keys.length,
      itemBuilder: (context, entryIndex) {
        final account = accounts[entryIndex];
        return ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: const Icon(Icons.monetization_on),
            title: Text(widget.balanceResult.balances[account]?.toString() ?? ''),
        );
      }
  );

}