import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'model/model.dart';

class EvolutionsTab extends StatefulWidget {
  final Query query;

  final List<Widget> Function(BuildContext, String, DateRange?)? actionsBuilder;

  const EvolutionsTab({required this.query, this.actionsBuilder, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EvolutionsTab> {
  static const queryExecutor = QueryExecutor();
  late final Ledger ledger;
  late final ValueNotifier<Query> query = ValueNotifier(widget.query);
  BalanceResult? balanceResult;

  @override
  void initState() {
    super.initState();
    ledger = context.read<AppModel>().ledger;

    loadBalances();
    query.addListener(loadBalances);
  }

  @override
  void dispose() {
    query.removeListener(loadBalances);
    super.dispose();
  }

  loadBalances() {
    Future(() => queryExecutor.queryBalance(ledger, query.value)).then((balanceResult) {
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
    return Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: QueryEditorBar(
              ledger: ledger,
              query: query,
              allowGroupedBy: true,
            ),
          ),
          Expanded(
              child: EvolutionsTable(
                key: ValueKey(balanceResult.hashCode),
                actionsBuilder: widget.actionsBuilder,
                balanceResult: balanceResult,
              )
          )
        ]
    );
  }

}