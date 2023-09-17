import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';

class AppModel {

  var preferencesLoading = ValueNotifier(false);
  var ledgerPreferences = LedgerPreferences.empty;

  var ledgerSource = ValueNotifier<LedgerSource?>(null);
  var ledgerLoading = ValueNotifier(false);
  var ledger = Ledger();

  var balancesQuery = ValueNotifier(Query());

  final tabQueries = QueryList();


}