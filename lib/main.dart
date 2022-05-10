import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoz_app/controllers/bindings/auth_binding.dart';
import 'package:todoz_app/controllers/localization_controller.dart';
import 'package:todoz_app/core//root.dart';
import 'package:todoz_app/core/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const _options = FirebaseOptions(
    apiKey: 'AIzaSyBDxH__-D6akkSdY04JwU__QW1J4GyPFn0',
    appId: '1:1061938235288:web:6f9ed6c64deefa0ce6cded',
    authDomain: "todoz-3aee8.firebaseapp.com",
    messagingSenderId: '1061938235288',
    projectId: 'todoz-3aee8',
    storageBucket: 'todoz-3aee8.appspot.com',
    measurementId: 'G-TX03FX0FV0',
  );

  kIsWeb
      ? await Firebase.initializeApp(options: _options)
      : await Firebase.initializeApp();

  await GetStorage().initStorage;
  Get.put<LocalizationController>(LocalizationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _localizationController = Get.find<LocalizationController>();
    return GetMaterialApp(
      title: 'Todozzz',
      translations: AppTranslations(),
      locale: _localizationController.currentLocale,
      initialBinding: AuthBinding(),
      fallbackLocale: const Locale('en', 'US'),
      home: const Root(),
    );
  }
}
