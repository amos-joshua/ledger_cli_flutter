import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

class LedgerLoadingView extends StatefulWidget {
  final String ledgerPath;
  final Widget child;

  const LedgerLoadingView({required this.ledgerPath, required this.child, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LedgerLoadingView> {
  static const ledgerFileLoader = LedgerFileLoader();
  bool didLoad = false;

  @override
  void initState() {
    super.initState();
    final ledgerSession = LedgerSession.of(context);
    final updateFromFile = LedgerUpdateRequestFromPath(widget.ledgerPath, execute: () {
      print("DBG loading data from ${widget.ledgerPath}");
      ledgerFileLoader.load(widget.ledgerPath, onApplyFailure: (edit, exc, stackTrace) {
        print("ERROR: could not apply $edit: $exc\n$stackTrace");
      }).then((newLedger) {
        setState(() {
          ledgerSession.ledger.loadFrom(newLedger);
          didLoad = true;
        });
      });
    });
    didLoad = !ledgerSession.processUpdateRequest(updateFromFile);
  }

  @override
  Widget build(BuildContext context) {
    return didLoad ? widget.child :
        const Center (
          child: CircularProgressIndicator(),
        );
  }

}