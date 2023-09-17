import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/app_controller.dart';
import '../model/app_model.dart';

class DependenciesProvider {
  final AppController _appController;
  final AppModel _appModel;

  late final appController = Provider((ref) => _appController);
  late final appModel = Provider((ref) => _appModel);

  late final preferencesLoading = ChangeNotifierProvider((ref) => _appModel.preferencesLoading);
  late final ledgerLoading = ChangeNotifierProvider((ref) => _appModel.ledgerLoading);
  late final ledgerSource = ChangeNotifierProvider((ref) => _appModel.ledgerSource);
  late final balancesQuery = ChangeNotifierProvider((ref) => _appModel.balancesQuery);
  late final tabQueries= ChangeNotifierProvider((ref) => _appModel.tabQueries);

  DependenciesProvider({required AppController appController, required AppModel appModel}): _appController = appController, _appModel = appModel;
}