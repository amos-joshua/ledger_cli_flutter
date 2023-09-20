import 'package:flutter/widgets.dart';
import 'package:ledger_cli/ledger_cli.dart';

class PreferencesLoadingAttr extends ValueNotifier<bool> {
  PreferencesLoadingAttr(super.value);
}

class LedgerLoadingAttr extends ValueNotifier<bool> {
  LedgerLoadingAttr(super.value);
}

class LedgerSourceAttr extends ValueNotifier<LedgerSource?> {
  LedgerSourceAttr(super.value);
}

class BalancesQueryAttr extends ValueNotifier<Query> {
  BalancesQueryAttr(super.value);
}

class SelectedTabIndexAttr extends ValueNotifier<int> {
  SelectedTabIndexAttr(super.value);
}