import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/authController.dart';
import 'package:todoz_app/controllers/userController.dart';
import 'package:todoz_app/pages/home.dart';
import 'package:todoz_app/pages/signUp.dart';
import 'package:todoz_app/widgets/tab_view_home.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AuthController(),
        initState: (_) async {
          Get.put<UserController>(UserController());
        },
        builder: (_) {
          if (Get.find<AuthController>().user?.uid != null) {
            return TabViewHome();
          } else {
            return SignUp();
          }
        });
  }
}
