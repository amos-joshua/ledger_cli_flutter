import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';

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
  const LedgerTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: QueryTabBar(),
            title: const Text('Ledger'),
          ),
          body: TabBarView(
                  children: [
                    Icon(Icons.balance),
                    Icon(Icons.list),
                  ],
                ),)
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.balance)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
          title: const Text('Ledger'),
        ),
        body: Column(
          children:[
            QueryEditorBar(),
          Expanded(child:const TabBarView(
          children: [
            Icon(Icons.balance),
            Icon(Icons.list),
          ],
        ),)
      ])
      ),
    );
  }*/
}