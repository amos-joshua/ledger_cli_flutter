import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

import 'ledger_loading_view.dart';
import 'balance_tab.dart';
import 'entries_list_tab.dart';
import 'entries_tab_label.dart';

class TabBarContainer extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  const TabBarContainer({required this.child});

  @override
  Widget build(BuildContext context) => child;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 60.0);

}

class BalancesScreen extends StatefulWidget {
  final String ledgerPath;
  const BalancesScreen({required this.ledgerPath, super.key});

  @override
  State createState() => _State();
}

class _State extends State<BalancesScreen> with TickerProviderStateMixin {
  final ledgerSession = LedgerSession(ledger: Ledger());
  final List<List<String>> tabAccounts = [];
  final List<LedgerSession> tabSessions = [];


  void showEntriesScreen(List<String> accounts) {
    print("DBG ledgerSession has ${ledgerSession.ledger.entries.length} entries");
    setState(() {
      tabAccounts.add(accounts);
      final newSession = LedgerSession(ledger: ledgerSession.ledger);
      newSession.query.value = newSession.query.value.modify(accounts: accounts);
      tabSessions.add(newSession);
    });
    //ledgerSession.query.value = ledgerSession.query.value.modify(accounts: accounts);

  }

  @override
  Widget build(BuildContext context) {
    final tabController = TabController(
        length: 1 + tabAccounts.length,
        initialIndex: tabAccounts.length,
        vsync: this
    );

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        actions: [
           AccountSelectorButton(ledgerSession: ledgerSession)
        ],
        bottom: TabBarContainer(
          child: TabBar(
              controller: tabController,
              tabs:[
                const Tab(text: 'Balances',),
                ...tabAccounts.asMap().entries.map((tabEntry) => EntriesTabLabel(
                    index: tabEntry.key + 1,
                    label: tabEntry.value.join(','),
                    onDelete: () {
                      setState(() {
                        tabAccounts.removeAt(tabEntry.key);
                        tabSessions.removeAt(tabEntry.key);
                      });
                    },
                    tabController: tabController
                )
                )
              ]
          )
        )
      ),
      body: Column(
          children: [
            Expanded(child:TabBarView(
              controller: tabController,
              children: [
                LedgerSessionContainer(
                ledgerSession: ledgerSession,
                child: LedgerLoadingView(
                  key: ValueKey(widget.ledgerPath),
                  ledgerPath: widget.ledgerPath,
                  child: BalanceTab(
                    onAccountDoubleTap: (account) => showEntriesScreen([account]),
                  ),
                  ),
                ),
                ...tabSessions.map((ledgerSession) => LedgerSessionContainer(
                    ledgerSession: ledgerSession,
                    child:  EntriesListTab(
                      ledgerSession: ledgerSession,
                    )
                  )
                )
              ]
            ))
          ]
      )
    );
  }
}