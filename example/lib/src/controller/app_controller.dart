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

  Future<void> loadPreferences(String path) async {
    model.preferencesLoading.value = true;
    try {
      final preferences = await ledgerPreferencesLoader.loadFromPath(path);
      model.ledgerPreferences = preferences;
      model.ledgerSource.value = LedgerSource.forFile(preferences.defaultLedgerFile);
    }
    catch (exc, stackTrace) {
      _errorStreamController.add(UserFacingError(message: 'Error loading ledger preferences: $exc', stackTrace: stackTrace));
    }
    model.preferencesLoading.value = false;
  }

  Future<void> loadLedger(LedgerSource source) async {
    model.ledgerLoading.value = true;
    try {
      model.ledger = await ledgerLoader.load(source, onApplyFailure: (edit, exc, stackTrace) {
        //print("ERROR: could not apply $edit: $exc\n$stackTrace");
        // TODO: file away in model error log
      });
      ledgerSourceWatcher.watch(source);
    }
    catch (exc, stackTrace) {
      _errorStreamController.add(UserFacingError(message: 'Error loading ledger from $source: $exc', stackTrace: stackTrace));
    }
    model.ledgerLoading.value = false;
  }

  void addAccountTab(List<String> accounts, {bool groupBy = false, DateRange? dateRange}) {
    final newQuery = Query()..accounts = accounts;
    if (groupBy) {
      newQuery.groupBy = PeriodLength.month;
      newQuery.startDate = DateTime(DateTime.now().year, 01, 01);
    }
    if (dateRange != null) {
      newQuery.startDate = dateRange.startDateInclusive;
      newQuery.endDate = dateRange.endDateInclusive;
    }
    model.tabQueries.add(newQuery);
    model.selectedTabIndex.value = model.tabQueries.length;
  }
}