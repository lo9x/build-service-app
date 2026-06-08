import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/services/app_repository.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  final repository = AppRepositoryFactory.create();
  final authController = AuthController(
    repository: repository,
    tokenStorage: tokenStorage,
  );

  await authController.restoreSession();

  runApp(
    ServiceMarketplaceApp(
      repository: repository,
      authController: authController,
    ),
  );
}
