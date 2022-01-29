import 'package:get/get.dart';
import 'package:todoz_app/models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;

  UserModel get userModel => _userModel.value;

  set userModel(UserModel value) => this._userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }
}
