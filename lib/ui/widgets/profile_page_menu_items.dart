import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';

class ProfilePageMenuItems extends PopupMenuItem {
  static final List<CustomMenuItem> listOne = [itemChangeLanguage];

  static final List<CustomMenuItem> listTwo = [itemSingOut];

  static final itemChangeLanguage = CustomMenuItem(
    text: 'changeLanguage'.tr,
    icon: EvaIcons.globe,
  );

  static final itemSingOut =
      CustomMenuItem(text: 'signOut'.tr, icon: EvaIcons.logOut);

  const ProfilePageMenuItems(Key? key, {required Widget? child})
      : super(key: key, child: child);
}

class CustomMenuItem {
  final String text;
  final IconData icon;
  final TodoSortType? todoSortType;
  final ProjectSortType? projectSortType;

  const CustomMenuItem({
    required this.text,
    required this.icon,
    this.todoSortType,
    this.projectSortType,
  });
}
