import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'controller/app_controller.dart';
import 'model/model.dart';

class BalanceTab extends StatefulWidget {

  //final List<Widget> Function(BuildContext, String)? actionsBuilder;

  //const BalanceTab({ this.actionsBuilder, super.key});
  const BalanceTab({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BalanceTab> {
  static const queryExecutor = QueryExecutor();
  late final ValueNotifier<Query> query;
  late final Ledger ledger;
  BalanceResult? balanceResult;

  @override
  void initState() {
    super.initState();
    ledger = context.read<AppModel>().ledger;
    query = context.read<BalancesQueryAttr>();
    loadBalances();
  }

  Future<void> loadBalances() async {
    try {
      final balanceResult = queryExecutor.queryBalance(ledger, query.value);
      setState(() {
        this.balanceResult = balanceResult;
      });
    }
    catch (error, stackTrace) {
      print("Query error: $error \n$stackTrace");
    }

    query.addListener(loadBalances);
  }

  @override
  void dispose() {
    query.removeListener(loadBalances);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = context.read<AppController>();

    final balanceResult = this.balanceResult;
    if (balanceResult == null) return const Center(child: CircularProgressIndicator());
    return Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: QueryEditorBar(
              ledger: ledger,
              query: query,
              searchFiltersAccounts: true,
              allowStartDate: false,
              allowGroupedBy: false,
            ),
          ),
          Expanded(
              child: BalanceTable(
                  key: ValueKey(balanceResult.hashCode),
                  balanceResult: balanceResult,
                  onDoubleTap: (account) {
                    print("tapped account $account");
                    appController.addAccountTab(account);
                  },
                  //actionsBuilder: widget.actionsBuilder
              )
          )
        ]
    );

  }

}