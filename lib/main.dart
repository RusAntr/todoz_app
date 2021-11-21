import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:todoz_app/controllers/bindings/authBinding.dart';
import 'package:todoz_app/utils/root.dart';
import 'package:todoz_app/utils/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('ru', 'RU'),
      initialBinding: AuthBinding(),
      home: Root(),
    );
  }
}
