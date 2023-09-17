import 'providers/provider.dart';
import 'controller/app_controller.dart';
import 'model/app_model.dart';

final providers = DependenciesProvider(
    appController: AppController(),
    appModel: AppModel()
);