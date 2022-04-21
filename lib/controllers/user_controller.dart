import 'package:get/get.dart';
import 'package:todoz_app/data/api/firestore_api.dart';
import '../data/models/models.dart';
import 'auth_controller.dart';

class UserController extends GetxController {
  /// Observable [UserModel]
  final Rx<UserModel> _userModel = UserModel().obs;

  /// Getter for [UserController]
  UserModel get userModel => _userModel.value;

  /// Setter for [UserController]
  set userModel(UserModel value) => _userModel.value = value;

  late String _uid;

  final _firestoreRepository = FirestoreApi();

  @override
  onInit() {
    _uid = Get.find<AuthController>().user!.uid;
    if (Get.find<AuthController>().user != null) {
      String _uid = Get.find<AuthController>().user!.uid;
      _userModel.bindStream(_firestoreRepository.getUserStream(_uid));
    }
    super.onInit();
  }

  /// Updates [UserModel]'s name property
  void updateUsername(String newName) =>
      _firestoreRepository.updateUsername(_uid, newName);
}
