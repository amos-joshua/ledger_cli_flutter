import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class PreferencesLoadingView extends ConsumerStatefulWidget {
  final Widget child;
  const PreferencesLoadingView({required this.child, super.key});

  @override
  ConsumerState createState() => _State();
}

class _State extends ConsumerState<PreferencesLoadingView> {
  bool didTryLoadingPreferences = false;

  @override
  void initState() {
    super.initState();
    final appController = ref.read(providers.appController);
    if (!didTryLoadingPreferences) {
      appController.loadPreferences('ledger-preferences.json');
      setState(() {
        didTryLoadingPreferences = true;
      });
    }
  }

  Widget loadingAnimation() => const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final loading = ref.read(providers.preferencesLoading).value;
    return loading ? loadingAnimation() : widget.child;
  }
}