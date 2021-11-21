// ignore_for_file: file_names
import 'package:get/get.dart';
import 'package:todoz_app/controllers/authController.dart';
import 'package:todoz_app/controllers/todoController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
