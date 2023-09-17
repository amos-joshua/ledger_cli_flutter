import 'package:flutter/material.dart';

import 'ledger_session.dart';

class LedgerSessionContainer extends StatefulWidget {
  final Widget child;
  final LedgerSession ledgerSession;

  const LedgerSessionContainer({required this.child, required this.ledgerSession, super.key});

  @override
  State<StatefulWidget> createState() => LedgerSessionContainerState();
}

class LedgerSessionContainerState extends State<LedgerSessionContainer> {
  @override
  void initState() {
    super.initState();
    print("DBG creating LedgerSessionContainer [key: ${widget.key}]");
  }

  @override
  Widget build(BuildContext context) {
    return InheritedLedgerSessionContainer(
      ledgerSession: widget.ledgerSession,
      child: widget.child
    );
  }
}


class InheritedLedgerSessionContainer extends InheritedWidget {
  final LedgerSession ledgerSession;
  const InheritedLedgerSessionContainer({super.key, required super.child, required this.ledgerSession});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
