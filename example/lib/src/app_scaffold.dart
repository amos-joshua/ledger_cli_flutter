import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'providers.dart';

class AppScaffold extends ConsumerWidget {
  Widget child;
  AppScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ledger')
      ),
      body: child,
    );
  }
}