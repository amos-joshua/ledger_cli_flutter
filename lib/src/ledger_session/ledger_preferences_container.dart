import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class LedgerPreferencesContainer extends StatefulWidget {
  final Widget child;
  final String ledgerPreferencesPath;
  final void Function(String) onError;

  const LedgerPreferencesContainer({required this.child, required this.ledgerPreferencesPath, required this.onError, super.key});

  @override
  State<StatefulWidget> createState() => LedgerPreferencesContainerState();

  static LedgerPreferences preferencesOf(BuildContext context) {
    final container = context.findAncestorWidgetOfExactType<InheritedLedgerPreferencesContainer>();
    if (container == null) {
      throw 'Cannot find InheritedLedgerPreferences in widget tree, the ledger cannot be retrieved. This is generally the result of calling LedgerPreferencesContainer.preferencesOf(context) on a widget that is not a descendant of LedgerPreferencesContainer';
    }
    return container.ledgerPreferences;
  }
}

class LedgerPreferencesContainerState extends State<LedgerPreferencesContainer> {
  final ledgerPreferencesParser = LedgerPreferencesParser();
  late final LedgerPreferences ledgerPreferences;
  var didLoad = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }
  
  Future<void> loadPreferences() async {
    final preferencesFile = File(widget.ledgerPreferencesPath);
    try {
      final cwd = Directory.current.absolute;
      if (!await preferencesFile.exists()) throw Exception('Ledger preferences file "${widget.ledgerPreferencesPath}" does not exist (cwd: [$cwd])');
      final preferencesData = await preferencesFile.readAsString();
      final loadedPreferences = ledgerPreferencesParser.parse(preferencesData);
      setState((){
        ledgerPreferences = loadedPreferences;
        didLoad = true;
      });
    }
    catch (err, stackTrace) {
      widget.onError('Could not load preferences: $err\n\n$stackTrace');
      setState(() {
        ledgerPreferences = LedgerPreferences.empty;
        didLoad = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (didLoad) {
      return InheritedLedgerPreferencesContainer(
          ledgerPreferences: ledgerPreferences,
          child: widget.child
      );
    }
    else {
      return const Center(
        child: SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator()
        )
      );
    }
  }
}


class InheritedLedgerPreferencesContainer extends InheritedWidget {
  final LedgerPreferences ledgerPreferences;
  const InheritedLedgerPreferencesContainer({super.key, required super.child, required this.ledgerPreferences});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

