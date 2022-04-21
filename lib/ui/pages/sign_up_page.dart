import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/ui/pages/log_in_page.dart';
import 'package:todoz_app/ui/widgets/animations/sign_up_animation.dart';
import '../../core/constants/constants.dart';

class SignUp extends GetWidget<AuthController> {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainPurple,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _signUpAnimation(),
                _userInput(),
                _signUpButtons(),
                const SizedBox(height: 15.0),
                Text(
                  'existingAccount'.tr,
                  style: AppTextStyles.whiteTitleNormal.copyWith(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5.0),
                _logInButton(),
                const SizedBox(height: 20.0)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _logInButton() {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 40.0,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.5),
        ),
      ),
      onPressed: () => Get.to(() => LogIn()),
      child: Text(
        'logIn'.tr,
        style: AppTextStyles.whiteTitleNormal,
      ),
    );
  }

  Widget _signUpButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              controller.signInWithGoogle();
            },
            icon: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/Google_Logo.svg?alt=media&token=027f0ea1-2958-426a-8103-30326a3255e8',
              height: 15.0,
              width: 15.0,
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
            label: Text(
              'signUpGoogle'.tr,
              style: AppTextStyles.blackTitleNormal,
            ),
          ),
          TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 30.0,
                  ),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () => controller.createUser(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                  ),
              child: Text(
                'signUp'.tr,
                style: AppTextStyles.whiteTitleNormal,
              )),
        ],
      ),
    );
  }

  Widget _userInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'nameTitle'.tr,
            style: AppTextStyles.whiteTitleBold.copyWith(fontSize: 13.0),
          ),
          const SizedBox(height: 5.0),
          TextField(
            style: AppTextStyles.blackTitleNormal,
            controller: _nameController,
            decoration: AppInputDecoarations.signUpTextField.copyWith(
                prefixIcon: const Icon(
                  EvaIcons.personOutline,
                  color: Colors.black,
                ),
                hintText: 'nameSignUp'.tr),
          ),
          const SizedBox(height: 15.0),
          Text(
            'emailTitle'.tr,
            style: AppTextStyles.whiteTitleBold.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 5.0),
          TextField(
            style: AppTextStyles.blackTitleNormal,
            controller: _emailController,
            autofillHints: const [AutofillHints.email],
            decoration: AppInputDecoarations.signUpTextField.copyWith(
              hintText: 'emailSignUp'.tr,
              prefixIcon: const Icon(
                EvaIcons.emailOutline,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            'passwordTitle'.tr,
            style: AppTextStyles.whiteTitleBold.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 10),
          TextField(
            obscureText: true,
            style: AppTextStyles.blackTitleNormal,
            controller: _passwordController,
            decoration: AppInputDecoarations.signUpTextField
                .copyWith(hintText: 'passwordSignUp'.tr),
          ),
        ],
      ),
    );
  }

  Widget _signUpAnimation() {
    return SizedBox(
      height: 230.0,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Positioned(
            top: .0,
            child: SignUpAnimation(),
          ),
          Positioned(
            bottom: .0,
            child: Text(
              'Let\'s Get Started!',
              style: AppTextStyles.whiteHeader.copyWith(fontSize: 32.0),
            ),
          ),
        ],
      ),
    );
  }
}
