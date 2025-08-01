import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_flow_kit/config/routes/app_router.dart';
import 'package:get_flow_kit/config/translation/app_translation.dart';
import 'package:get_flow_kit/global_binding.dart';
import 'package:get_storage/get_storage.dart';

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
      getPages: AppRouter.pages,
      initialBinding: GlobalBinding(),
    );
  }
}
