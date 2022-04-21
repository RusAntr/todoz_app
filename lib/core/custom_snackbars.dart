import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/core/constants/colors.dart';
import 'package:todoz_app/data/api/firestore_api.dart';
import '../data/models/models.dart';

class CustomSnackbars {
  static error(
    String title,
    String message,
  ) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(
        Icons.cancel,
        color: AppColors.mainRed,
      ),
      shouldIconPulse: false,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(20.0),
      backgroundColor: Colors.white,
      isDismissible: true,
    );
  }

  static undoDeleteTodo({
    required String title,
    required String message,
    required String projectId,
    required TodoModel deletedTodo,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(
        EvaIcons.fileRemove,
        color: AppColors.mainRed,
      ),
      duration: const Duration(seconds: 2),
      mainButton: TextButton(
        onPressed: () {
          FirestoreApi()
              .restoreTodo(
                deletedTodoModel: deletedTodo,
                uid: Get.find<AuthController>().user!.uid,
                projectId: projectId,
              )
              .whenComplete(
                () => Get.closeAllSnackbars(),
              );
        },
        child: Text('undo'.tr),
      ),
      shouldIconPulse: false,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(20.0),
      backgroundColor: Colors.white,
      isDismissible: true,
    );
  }
}
