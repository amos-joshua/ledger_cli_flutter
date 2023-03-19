import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

class EvolutionsTab extends StatefulWidget {
  final List<Widget> Function(BuildContext, String, DateRange?)? actionsBuilder;

  const EvolutionsTab({this.actionsBuilder, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EvolutionsTab> {
  late LedgerSession ledgerSession;
  BalanceResult? balanceResult;

  @override
  void initState() {
    super.initState();
    ledgerSession = LedgerSession.of(context);
    loadBalances();
    ledgerSession.query.addListener(loadBalances);
  }

  @override
  void dispose() {
    ledgerSession.query.removeListener(loadBalances);
    super.dispose();
  }

  loadBalances() {
    Future(() => ledgerSession.queryExecutor.queryBalance(ledgerSession.ledger, ledgerSession.query.value)).then((balanceResult) {
      setState(() {
        this.balanceResult = balanceResult;
      });
    }).catchError((error, stackTrace) {
      print("Query error: $error \n$stackTrace");
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceResult = this.balanceResult;
    if (balanceResult == null) return const Center(child:CircularProgressIndicator());
    return EvolutionsTable(
        key: ValueKey(balanceResult.hashCode),
        actionsBuilder: widget.actionsBuilder,
        balanceResult: balanceResult,
    );
  }

}