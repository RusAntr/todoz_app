// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/userController.dart';
import 'package:todoz_app/models/userModel.dart';
import 'package:todoz_app/pages/home.dart';
import 'package:todoz_app/pages/signUp.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/root.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  User? get user => _firebaseUser.value;

  @override
  onInit() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  /// Calls firebase, creates user, will be automatically updated.
  void createUser(String name, String email, String password) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      /// Creates user in database.dart
      UserModel _user = UserModel(
          id: _userCredential.user?.uid,
          email: _userCredential.user?.email,
          name: name);
      if (await Database().createNewUser(_user)) {
        Get.find<UserController>().userModel = _user;
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void login(String email, String password) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.find<UserController>().userModel =
          await Database().getUser(_userCredential.user!.uid);
      update();

      (_auth.currentUser != null)
          ? Get.to(() => Home())
          : Get.snackbar('title', 'message');
    } catch (e) {
      Get.snackbar('Log In Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Signs user out of the app.
  void signOut() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().clear();
      Get.offAll(Root());
      Get.to(SignUp());
    } catch (e) {
      Get.snackbar('Sign Out Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
