import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

import 'ledger_loading_view.dart';
import 'balance_tab.dart';
import 'entries_list_tab.dart';

class QueryTabBar extends StatelessWidget implements PreferredSizeWidget {
  const QueryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Padding(
          padding: EdgeInsets.all(5.0),
          child: QueryEditorBar(),
        ),
        TabBar(
          tabs: [
            Tab(icon: Icon(Icons.balance)),
            Tab(icon: Icon(Icons.list)),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 120.0);
}

class LedgerTabScreen extends StatelessWidget {
  final String ledgerPath;
  final ledgerSession = LedgerSession(ledger: Ledger());

  LedgerTabScreen({required this.ledgerPath, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: LedgerSessionContainer(
        ledgerSession: ledgerSession,
        child:Scaffold(
          appBar: AppBar(
            bottom: const QueryTabBar(),
            title: const Text('Ledger'),
          ),
          body: LedgerLoadingView(
            ledgerPath: ledgerPath,
            child: const TabBarView(
              children: [
                BalanceTab(),
                EntriesListTab()
              ],
            ),
          ))
      )
    );
  }
}