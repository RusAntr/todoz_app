import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/ui/widgets/animations/login_animation.dart';
import '../../core/constants/constants.dart';

class LogIn extends GetWidget<AuthController> {
  LogIn({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainPurple,
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                const SizedBox(
                  height: 200,
                  child: LogInAnimation(),
                ),
                Text('Welcome Back!', style: AppTextStyles.whiteHeader),
                _userInput(),
                const SizedBox(height: 15.0),
                _logInButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextButton _logInButton() {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 40.0,
              ),
            ),
            side: MaterialStateProperty.all(
              const BorderSide(color: AppColors.mainPurple),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.black)),
        onPressed: () => controller.login(
              _emailController.text,
              _passwordController.text,
            ),
        child: Text(
          'logIn'.tr,
          style: AppTextStyles.whiteTitleNormal,
        ));
  }

  Padding _userInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'emailTitle'.tr,
            style: AppTextStyles.whiteTitleBold,
          ),
          const SizedBox(height: 10.0),
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
              )),
          const SizedBox(height: 15.0),
          Text(
            'passwordTitle'.tr,
            style: AppTextStyles.whiteTitleBold,
          ),
          const SizedBox(height: 10.0),
          TextField(
              obscureText: true,
              style: AppTextStyles.blackTitleNormal,
              controller: _passwordController,
              decoration: AppInputDecoarations.signUpTextField
                  .copyWith(hintText: 'passwordSignUp'.tr)),
        ],
      ),
    );
  }
}
