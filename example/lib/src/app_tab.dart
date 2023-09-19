
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

enum  AppTabType {
  transactions, evolution
}

class AppTab {
  final List<String> accounts;
 // final LedgerSession ledgerSession;
  final AppTabType appTabType;
  AppTab({required this.accounts, /*required this.ledgerSession,*/ required this.appTabType});

}