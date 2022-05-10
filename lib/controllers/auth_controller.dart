import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/data/models/models.dart';
import 'package:todoz_app/core/custom_snackbars.dart';
import 'package:todoz_app/core/root.dart';
import '../data/api/firestore_api.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _firestoreRepository = FirestoreApi();

  /// Observable [User]
  late Rx<User?> _firebaseUser;

  /// Getter for [AuthController]
  User? get user => _firebaseUser.value;

  @override
  onInit() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  /// Calls [FirebaseFirestore], creates user, will be automatically updated
  void createUser(String name, String email, String password) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      /// Creates user in [FirebaseRepository]
      UserModel _user = UserModel(
          id: _userCredential.user?.uid,
          email: _userCredential.user?.email,
          name: name);
      if (await _firestoreRepository.createNewUser(_user)) {
        Get.find<UserController>().userModel = _user;
        Get.back();
      }
    } on FirebaseAuthException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }

  /// Signs user in the app
  void login(String email, String password) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.find<UserController>().userModel = await _firestoreRepository
          .getUser(_userCredential.user!.uid) as UserModel;
      update();
      (_auth.currentUser != null)
          ? Get.to(() => const Root())
          : Get.snackbar('title', 'message');
    } on FirebaseAuthException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }

  /// Signs Google user in the app and creates [User] in [FirestoreApi]
  Future<void> signInWithGoogle() async {
    if (user != null) {
      throw Exception();
    } else {}
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential _userCredential =
          await _auth.signInWithCredential(credential);

      UserModel _user;

      /// Checks if [UserModel] exists in database, if not creates it
      _user = await _firestoreRepository.getUser(_userCredential.user!.uid) ??
          UserModel(
            id: _userCredential.user!.uid,
            email: _userCredential.user!.email,
            name: _userCredential.user!.displayName,
          );

      await _firestoreRepository.createNewUser(_user);

      Get.find<UserController>().userModel = _user;
      Get.back();
    } on FirebaseAuthException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }

  /// Clears controllers and signs user out of the app
  void signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Get.reloadAll(force: true);
      Get.offAll(const Root());
    } on FirebaseAuthException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }
}
