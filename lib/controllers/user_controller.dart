import 'package:get/get.dart';
import 'package:todoz_app/models/user_model.dart';
import 'package:todoz_app/services/database.dart';

import 'auth_controller.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;

  @override
  onInit() {
    String _uid = Get.find<AuthController>().user!.uid;
    _userModel.bindStream(Database().getUserStream(_uid));
    super.onInit();
  }

  UserModel get userModel => _userModel.value;

  set userModel(UserModel value) => _userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }
}
