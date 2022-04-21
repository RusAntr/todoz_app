import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  final GetStorage _box = GetStorage();

  /// Observable [Locale]
  final Rx<Locale?> _currentLocale = Get.locale.obs;

  /// Getter for [LocalizationController]
  Locale get currentLocale => _currentLocale.value!;

  @override
  void onInit() {
    initLanguage();
    super.onInit();
  }

  /// Returns name of the currently used language
  get currentLanguage {
    switch (_currentLocale.value!.languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'zh':
        return '简体中文';
      default:
        return _currentLocale.value!.languageCode;
    }
  }

  /// Returns [LocaleType] for a [DatePicker]
  LocaleType get currentLocaleType {
    if (currentLocale.languageCode == 'en') {
      return LocaleType.en;
    } else if (currentLocale.languageCode == 'ru') {
      return LocaleType.ru;
    } else if (currentLocale.languageCode == 'zh') {
      return LocaleType.zh;
    } else {
      return LocaleType.en;
    }
  }

  /// Checks if the [GetStorage] has a language [Locale] stored. If so restores it.
  /// If theres is no language stored current locale will be the device's locale
  void initLanguage() {
    if (_box.read('language') != null) {
      _restoreLanguage();
    } else {
      Locale? deviceLocale = Get.deviceLocale;
      if (deviceLocale!.languageCode != 'en' ||
          deviceLocale.languageCode != 'ru' ||
          deviceLocale.languageCode != 'zh') {
        _currentLocale.value = const Locale(
          'en',
          'US',
        );
        _box.write(
          'language',
          'en',
        );
      } else {
        _box.write(
          'language',
          _currentLocale.value!.languageCode,
        );
      }
    }
  }

  /// Changes app's language, updates current [Locale]
  void changeLanguage(String languageCode, String countryCode) {
    _currentLocale.value = Locale(languageCode, countryCode);
    Get.updateLocale(_currentLocale.value!);
    _box.write('language', currentLocale.languageCode);
  }

  /// Restores app's language from [GetStorage]
  void _restoreLanguage() {
    var _langCode = _box.read('language');
    _currentLocale.value = Locale(_langCode, '');
  }
}
