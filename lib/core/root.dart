import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/ui/pages/main_page.dart';
import 'package:todoz_app/ui/pages/sign_up_page.dart';

class Root extends GetWidget<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: AuthController(),
      initState: (_) async {
        Get.put<UserController>(UserController());
        Get.put<ProjectController>(ProjectController());
      },
      builder: (_) {
        if (controller.user?.uid != null) {
          FlutterNativeSplash.remove();
          return const MainPage();
        } else {
          return SignUp();
        }
      },
    );
  }
}
