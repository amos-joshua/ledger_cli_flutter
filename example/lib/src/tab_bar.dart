import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:provider/provider.dart';

import 'entries_tab_label.dart';

class AppTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;

  const AppTabBar({required this.tabController, super.key});

  @override
  State<StatefulWidget> createState() => _State();

  @override
  Size get preferredSize => const Size(double.maxFinite, 60.0);
}

class _State extends State<AppTabBar> {
  @override
  Widget build(BuildContext context) {
    final tabQueries = context.watch<QueryList>();

    return TabBar(
      controller: widget.tabController,
      tabs:[
        const Tab(text: 'Balances'),
        ...tabQueries.asMap().entries.map((entry) => EntriesTabLabel(
            index: entry.key + 1,
            icon: entry.value.groupBy == null ? Icons.list : Icons.trending_up,
            label: entry.value.accounts.join(','),
            onDelete: () {
              setState(() {
                tabQueries.removeAt(entry.key);
              });
            },
            tabController: widget.tabController
          )
        )
      ]
    );
  }
}