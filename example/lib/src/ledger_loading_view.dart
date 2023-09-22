import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'model/model.dart';
import 'controller/app_controller.dart';
import 'select_a_file_screen.dart';

class LedgerLoadingView extends StatefulWidget {
  final Widget child;
  const LedgerLoadingView({required this.child, super.key});

  @override
  State createState() => _State();
}

class _State extends State<LedgerLoadingView> {
  Widget loadingAnimation() => const Center(
      child: Text('ledger loading')//CircularProgressIndicator()
  );
  LedgerSource? lastLoadedSource;


  @override
  Widget build(BuildContext context) {
    final ledgerSource = context.watch<LedgerSourceAttr>().value;
    final appController = context.read<AppController>();
    final loading = context.watch<LedgerLoadingAttr>().value;
    if ((ledgerSource != null) && (ledgerSource != lastLoadedSource)) {
      lastLoadedSource = ledgerSource;
      Future.delayed(const Duration(milliseconds: 150), () {
        // Note: delay loading the ledger, to avoid modifying state variables during build
        appController.loadLedger(ledgerSource);
      });
    }
    // TODO: make the app remember the last opened file and suggest that
    return loading ? loadingAnimation() : ledgerSource == null ? const SelectAFileScreen() : widget.child;
  }
}
