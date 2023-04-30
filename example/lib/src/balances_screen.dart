import 'dart:io';

import 'package:example/src/evolutions_tab.dart';
import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:file_picker/file_picker.dart';

import 'ledger_loading_view.dart';
import 'balance_tab.dart';
import 'entries_list_tab.dart';
import 'entries_tab_label.dart';
import 'app_tab.dart';
import 'import_screen.dart';
import 'error_dialog.dart';
import 'import_starter.dart';
import 'dialogs/dialogs.dart';


class TabBarContainer extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  const TabBarContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;

  @override
  Size get preferredSize => const Size(double.maxFinite, 60.0);

}

class BalancesScreen extends StatefulWidget {
  final LedgerPreferences ledgerPreferences;
  final String ledgerPath;
  const BalancesScreen({required this.ledgerPath, required this.ledgerPreferences, super.key});

  @override
  State createState() => _State();
}

class _State extends State<BalancesScreen> with TickerProviderStateMixin {
  //static const csvDataLoader = CsvDataLoader();
  final ledgerSession = LedgerSession(ledger: Ledger());

  final List<AppTab> tabs = [];


  void showEntriesScreen(List<String> accounts, [DateRange? dateRange]) {
    setState(() {
      final newTab = AppTab(
        accounts: accounts,
        ledgerSession:  LedgerSession(ledger: ledgerSession.ledger),
        appTabType: AppTabType.transactions
      );
      tabs.add(newTab);
      newTab.ledgerSession.query.value = newTab.ledgerSession.query.value.modify(accounts: accounts)
        ..startDate = dateRange?.startDateInclusive
        ..endDate = dateRange?.endDateInclusive;
    });
  }

  void showEvolutionScreen(List<String> accounts) {
    setState(() {
      final newTab = AppTab(
          accounts: accounts,
          ledgerSession:  LedgerSession(ledger: ledgerSession.ledger),
          appTabType: AppTabType.evolution
      );
      tabs.add(newTab);
      newTab.ledgerSession.query.value = newTab.ledgerSession.query.value.modify(
          accounts: accounts,
      )..groupBy = PeriodLength.month
       ..startDate = DateTime(DateTime.now().year, 01, 01);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabController = TabController(
        length: 1 + tabs.length,
        initialIndex: tabs.length,
        vsync: this
    );

    List<Widget> evolutionsActionSFor(BuildContext context, String account, DateRange? dateRange) {
      return [
        IconButton(
            onPressed: () => showEntriesScreen([account], dateRange),
            icon: const Icon(Icons.list, color: Colors.black54),
            tooltip: 'Transactions...'
        ),
      ];
    }

    List<Widget> balancesActionsFor(BuildContext context, String account) {
      return [
        IconButton(
            onPressed: () => showEntriesScreen([account]),
            icon: const Icon(Icons.list, color: Colors.black54),
            tooltip: 'Transactions...'
        ),
        IconButton(
            onPressed: () => showEvolutionScreen([account]),
            icon: const Icon(Icons.trending_up, color: Colors.black54), tooltip: 'Evolution...'),
      ];
    }

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        actions: [
          /*
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final shouldReload = await ConfirmDialog(context).show(
                  title: 'Reload data',
                  message: 'Reload data from ledger "${widget.ledgerPath}"?'
              );
              if (shouldReload != true) return;
              LedgerUpdateRequestFromPath(widget.ledgerPath);
              ledgerSession.processUpdateRequest(updateRequest)
              print("DBG reloading!");
              // TODO: add event channel (or find one) to ledger sessions, make it process update requests, make LedgerLoadingView listen to changes and update accoridngly
            },
          ),*/
          IconButton(
            icon: const Icon(Icons.move_to_inbox),
            onPressed: () {
              final importStarter = ImportStarter();
              importStarter.startImport(
                  context,
                  ledgerPreferences: widget.ledgerPreferences,
                  accountManager: ledgerSession.ledger.accountManager
              ).then((importSession) {
                if (importSession == null) return;
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImportScreen(importSession: importSession, ledgerPreferences: widget.ledgerPreferences)));
              });
            }
          ),
        ],
        bottom: TabBarContainer(
          child: TabBar(
              controller: tabController,
              tabs:[
                const Tab(text: 'Balances',),
                ...tabs.asMap().entries.map((tabEntry) => EntriesTabLabel(
                    index: tabEntry.key + 1,
                    icon: tabEntry.value.appTabType == AppTabType.transactions ? Icons.list : Icons.trending_up,
                    label: tabEntry.value.accounts.join(','),
                    onDelete: () {
                      setState(() {
                        tabs.removeAt(tabEntry.key);
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
                  ledgerPath: widget.ledgerPath,
                  child: BalanceTab(
                    actionsBuilder: balancesActionsFor,
                    onAccountDoubleTap: (account) => showEntriesScreen([account]),
                  ),
                  ),
                ),
                ...tabs.map((tab) => LedgerSessionContainer(
                    ledgerSession: tab.ledgerSession,
                    child:  tab.appTabType == AppTabType.transactions ? EntriesListTab(
                      ledgerSession: tab.ledgerSession,
                    ) :
                        EvolutionsTab(
                          key: ValueKey(tab.accounts),
                          actionsBuilder: evolutionsActionSFor,
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