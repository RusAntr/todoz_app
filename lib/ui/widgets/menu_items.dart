import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class MenuItems {
  static final List<MenuItem> listOne = [itemChangeLanguage];

  static final List<MenuItem> listTwo = [itemSingOut];

  static final itemChangeLanguage = MenuItem(
    text: 'changeLanguage'.tr,
    icon: EvaIcons.globe,
  );

  static final itemSingOut =
      MenuItem(text: 'signOut'.tr, icon: EvaIcons.logOut);
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({required this.text, required this.icon});
}
