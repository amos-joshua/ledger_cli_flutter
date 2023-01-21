import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class LedgerContainer extends StatefulWidget {
  final Widget child;
  final Ledger ledger;

  const LedgerContainer({required this.child, required this.ledger, super.key});

  static Ledger of(BuildContext context) {
    final container = context.findAncestorWidgetOfExactType<_InheritedLedgerContainer>();
    if (container == null) {
      throw 'Cannot find LedgerContainer in widget tree, the ledger cannot be retrieved. This is generally the result of calling LedgerContainer.of(context) on a widget that is not a descendant of LedgerContainer';
    }
    return container.ledger;
  }

  @override
  State<StatefulWidget> createState() => LedgerContainerState();
}

class LedgerContainerState extends State<LedgerContainer> {
  @override
  Widget build(BuildContext context) {
    return _InheritedLedgerContainer(
      ledger: widget.ledger,
      child: widget.child
    );
  }
}


class _InheritedLedgerContainer extends InheritedWidget {
  final Ledger ledger;
  const _InheritedLedgerContainer({required super.child, required this.ledger});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
