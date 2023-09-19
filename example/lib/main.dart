import 'package:example/src/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'src/ledger_loading_view.dart';
import 'src/preferences_loading_view.dart';
import 'src/app_scaffold.dart';
import 'src/balances_screen.dart';
import 'src/dependencies.dart';

void main() {
  runApp(
    DependenciesProvider(
      appController: AppController(),
      child: MaterialApp(
          title: 'Ledger CLI Explorer',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const AppScaffold()
      )
    )
  );
}
