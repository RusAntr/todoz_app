import 'package:flutter/cupertino.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  final Rx<Locale?> _currentLocale = Get.locale.obs;
  //final GetStorage _box = GetStorage();

  Locale get currentLocale => _currentLocale.value!;

  // @override
  // void onInit() {
  //   super.onInit();
  //   if (_box.read('language') != null) {
  //     _restoreLanguage();
  //   } else {
  //     _box.write('language', currentLocale);
  //   }
  //   _box.printInfo();
  // }

  // void changeLanguage(String languageCode, String countyCode) {
  //   _currentLocale.value = Locale(languageCode, countyCode);
  //   Get.updateLocale(_currentLocale.value!);
  //   _box.write('language', currentLocale);
  // }

  // void _restoreLanguage() {
  //   _box.read('language');
  // }
}
