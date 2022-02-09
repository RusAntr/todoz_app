import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/pages/sign_up_page.dart';
import 'package:todoz_app/pages/main_page.dart';

class Root extends GetWidget<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AuthController(),
        initState: (_) async {
          Get.put<UserController>(UserController());
        },
        builder: (_) {
          if (controller.user?.uid != null) {
            return const MainPage();
          } else {
            return SignUp();
          }
        });
  }
}
