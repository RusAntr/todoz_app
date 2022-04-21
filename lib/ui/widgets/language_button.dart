import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/localization_controller.dart';
import '../../core/constants/constants.dart';

class LanguageButton extends GetWidget<LocalizationController> {
  const LanguageButton({Key? key, required this.languageCode})
      : super(key: key);
  final String languageCode;

  String get emoji {
    switch (languageCode) {
      case 'ru':
        return '🇷🇺';
      case 'en':
        return '🇬🇧';
      case 'zh':
        return '🇨🇳';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.changeLanguage(languageCode, ''),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: controller.currentLocale.languageCode == languageCode
              ? AppColors.accentBlue
              : Colors.black.withOpacity(.05),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: AnimatedDefaultTextStyle(
          curve: Curves.easeIn,
          child: Text(emoji),
          style: controller.currentLocale.languageCode == languageCode
              ? AppTextStyles.textStyleBlackBigText.copyWith(fontSize: 25.0)
              : AppTextStyles.dateTimeItem,
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
