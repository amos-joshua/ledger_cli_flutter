import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'src/select_a_file_screen.dart';
import 'src/dialogs/error_dialog.dart';
import 'src/ledger_loading_view.dart';
import 'src/preferences_loading_view.dart';
import 'src/app_scaffold.dart';
import 'src/balances_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Ledger CLI Explorer',
        theme: ThemeData(primarySwatch: Colors.blue,),
        home: AppScaffold(
          child: PreferencesLoadingView(
            child: LedgerLoadingView(
              child: BalancesScreen()
            )
          )
        )
      )
    )
  );
}
