import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'providers.dart';

class LedgerLoadingView extends ConsumerStatefulWidget {
  final Widget child;

  const LedgerLoadingView({required this.child, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<LedgerLoadingView> {
  Widget loadingAnimation() => const Center(child: CircularProgressIndicator());
  LedgerSource? lastLoadedSource;

  @override
  Widget build(BuildContext context) {
    final ledgerSource = ref.watch(providers.ledgerSource).value;
    final appController = ref.watch(providers.appController);
    final loading = ref.read(providers.ledgerLoading).value;

    if ((ledgerSource != null) && (ledgerSource != lastLoadedSource)) {
      lastLoadedSource = ledgerSource;
      appController.loadLedger(ledgerSource);
    }

    return loading ? loadingAnimation() : ledgerSource == null ? SelectAFileScreen() : widget.child;
  }
}
