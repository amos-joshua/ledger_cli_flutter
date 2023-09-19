import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'attributes.dart';

class AppModel {
  final preferencesLoading = PreferencesLoadingAttr(false);
  var ledgerPreferences = LedgerPreferences.empty;

  var ledgerSource = LedgerSourceAttr(null);
  var ledgerLoading = LedgerLoadingAttr(false);
  var ledger = Ledger();

  var balancesQuery = BalancesQueryAttr(Query());

  final tabQueries = QueryList();


}