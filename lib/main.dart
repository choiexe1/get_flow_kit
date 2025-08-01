import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_flow_kit/global_binding.dart';
import 'package:get_storage/get_storage.dart';

import 'config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslation(),
      initialBinding: GlobalBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppRouter.pages,
    );
  }
}
