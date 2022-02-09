import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:todoz_app/controllers/bindings/auth_binding.dart';
import 'package:todoz_app/controllers/localization_controller.dart';
import 'package:todoz_app/utils/root.dart';
import 'package:todoz_app/services/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await GetStorage().initStorage;
//  Get.put<LocalizationController>(LocalizationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final _localizationController = Get.find<LocalizationController>();
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: window.locale,
      initialBinding: AuthBinding(),
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
        Locale('zh', '')
      ],
      fallbackLocale: const Locale('en', 'US'),
      home: const Root(),
    );
  }
}
