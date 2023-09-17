import 'dart:async';
import 'package:ledger_cli/ledger_cli.dart';

import '../model/app_model.dart';
import '../model/user_facing_error.dart';

class AppController  {
  static const ledgerPreferencesLoader = LedgerPreferencesLoader();
  static const ledgerLoader = LedgerLoader();
  late final ledgerSourceWatcher = LedgerSourceWatcher(
    onSourceChanged: (source) => model.ledgerSource.value = source
  );

  final _errorStreamController = StreamController<UserFacingError>.broadcast();
  Stream<UserFacingError> get errorStream => _errorStreamController.stream;
  final model = AppModel();

  void loadPreferences(String path) async {
    model.preferencesLoading.value = true;
    try {
      model.ledgerPreferences = await ledgerPreferencesLoader.loadFromPath(path);
    }
    catch (exc, stackTrace) {
      _errorStreamController.add(UserFacingError(message: 'Error loading ledger preferences: $exc', stackTrace: stackTrace));
    }
    model.preferencesLoading.value = false;
  }

  void loadLedger(LedgerSource source) async {
    model.ledgerLoading.value = true;
    try {
      model.ledger = await ledgerLoader.load(source, onApplyFailure: (edit, exc, stackTrace) {
        print("ERROR: could not apply $edit: $exc\n$stackTrace");
      });
      ledgerSourceWatcher.watch(source);
    }
    catch (exc, stackTrace) {
      _errorStreamController.add(UserFacingError(message: 'Error loading ledger from $source: $exc', stackTrace: stackTrace));
    }
    model.ledgerLoading.value = false;
  }
}