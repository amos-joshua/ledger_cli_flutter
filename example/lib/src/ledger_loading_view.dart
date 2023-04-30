import 'dart:io';
import 'dart:async';

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
  late final Directory ledgerParent;
  bool didLoad = false;
  StreamSubscription? fileSystemSubscription;
  DateTime? lastModifiedTimeLedger;

  @override
  void initState() {
    super.initState();
    ledgerParent = File(widget.ledgerPath).parent;
    ledgerParent.watch();
    fileSystemSubscription = ledgerParent.watch().listen(onFileSystemEvent);
    reloadLedgerFile(force: false);
  }

  @override
  void dispose() {
    fileSystemSubscription?.cancel();
    super.dispose();
  }

  void onFileSystemEvent(FileSystemEvent event) async {
    final ledger = File(widget.ledgerPath);
    final stat = await ledger.stat();
    if (stat.modified != lastModifiedTimeLedger) {
      lastModifiedTimeLedger = stat.modified;
      reloadLedgerFile(force: true);
    }
  }

  void reloadLedgerFile({required bool force}) {
    final ledgerSession = LedgerSession.of(context);
    final updateFromFile = LedgerUpdateRequestFromPath(widget.ledgerPath, execute: () {
      ledgerFileLoader.load(widget.ledgerPath, onApplyFailure: (edit, exc, stackTrace) {
        print("ERROR: could not apply $edit: $exc\n$stackTrace");
      }).then((newLedger) {
        setState(() {
          ledgerSession.ledger.clear();
          ledgerSession.ledger.loadFrom(newLedger);
          didLoad = true;
        });
      });
    }, force: force);
    ledgerSession.processUpdateRequest(updateFromFile);
    //didLoad = !ledgerSession.processUpdateRequest(updateFromFile);
  }

  @override
  Widget build(BuildContext context) {
    return didLoad ? widget.child :
        const Center (
          child: CircularProgressIndicator(),
        );
  }

}