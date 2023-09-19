import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/app_controller.dart';
import 'model/model.dart';


class PreferencesLoadingView extends StatefulWidget {
  final Widget child;
  const PreferencesLoadingView({required this.child, super.key});

  @override
  State createState() => _State();
}

class _State extends State<PreferencesLoadingView> {
  bool didTryLoadingPreferences = false;

  @override
  void initState() {
    super.initState();
    final appController = context.read<AppController>();
    if (!didTryLoadingPreferences) {
      appController.loadPreferences('ledger-preferences.json');
      setState(() {
        didTryLoadingPreferences = true;
      });
    }
  }

  Widget loadingAnimation() => const Center(
      child: Text('Preferences loading')//CircularProgressIndicator()
  );

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<PreferencesLoadingAttr>().value;
    return loading ? loadingAnimation() : widget.child;
  }
}