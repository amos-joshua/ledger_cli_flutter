import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';

import 'controller/app_controller.dart';
import 'dialogs/dialogs.dart';
import 'app_tab_bar.dart';
import 'import_screen.dart';
import 'import_starter.dart';
import 'preferences_loading_view.dart';
import 'ledger_loading_view.dart';
import 'app_tab_view.dart';
import 'model/model.dart';

class TabBarContainer extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  const TabBarContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;

  @override
  Size get preferredSize => const Size(double.maxFinite, 60.0);
}


class AppScaffold extends StatefulWidget {

  const AppScaffold({super.key});

  @override
  State createState() => _State();
}

class _State extends State<AppScaffold> with TickerProviderStateMixin {
  late final AppController appController;
  StreamSubscription? errorStreamSubscription;

  @override
  void initState() {
    super.initState();
    appController = context.read<AppController>();
    errorStreamSubscription = appController.errorStream.listen((error) {
      //print('App scaffold ERROR: ${error.message}\n${error.stackTrace}');
      AlertMessageDialog(context).show(
        title: 'Error',
        message: error.message
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<AppModel>();
    final ledgerSource = context.watch<LedgerSourceAttr>();
    final tabQueries = context.watch<QueryList>();

    final tabController = TabController(
        length: 1 + tabQueries.length,
        initialIndex: tabQueries.length,
        vsync: this
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        bottom: AppTabBar(tabController: tabController),
        actions: [
          IconButton(
            icon: const Icon(Icons.move_to_inbox),
            tooltip: 'Import',
            onPressed: () {
              final importStarter = ImportStarter();
              importStarter.startImport(
                  context,
                  ledgerPreferences: model.ledgerPreferences,
                  accountManager: model.ledger.accountManager
              ).then((importSession) {
                if (importSession == null) return;
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImportScreen(importSession: importSession, ledgerPreferences: model.ledgerPreferences)));
              });
            }
          ),
          IconButton(
            icon: const Icon(Icons.folder),
            tooltip: 'Open',
            onPressed: () {
              final initialDirectory = kIsWeb ? null : File(model.ledgerPreferences.defaultLedgerFile).parent.path;
              SelectLedgerFileDialog(context).show(initialDirectory: initialDirectory).then((source) {
                if (source != null) ledgerSource.value = source;
              });
            },
          )
        ],
      ),
      body: PreferencesLoadingView(
          child: LedgerLoadingView(
              child: AppTabView(tabController: tabController)
          )
      )
    );
  }
}