import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/app_controller.dart';
import 'dialogs/dialogs.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({required this.child, super.key});

  @override
  State createState() => _State();
}

class _State extends State<AppScaffold> {
  late final AppController appController;
  StreamSubscription? errorStreamSubscription;

  @override
  void initState() {
    super.initState();
    final appController = context.read<AppController>();
    errorStreamSubscription = appController.errorStream.listen((error) {
      print('App scaffold ERROR: ${error.message}\n${error.stackTrace}');
      AlertMessageDialog(context).show(
        title: 'Error',
        message: error.message
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger')
      ),
      body: widget.child,
    );
  }
}