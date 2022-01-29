import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/pages/sign_up_page.dart';
import 'package:todoz_app/widgets/tab_view_home.dart';

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
          if (Get.find<AuthController>().user?.uid != null) {
            return const TabViewHome();
          } else {
            return SignUp();
          }
        });
  }
}
