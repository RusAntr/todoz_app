import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class SignUpAnimation extends StatefulWidget {
  const SignUpAnimation({Key? key}) : super(key: key);

  @override
  SignUpAnimationState createState() => SignUpAnimationState();
}

class SignUpAnimationState extends State<SignUpAnimation> {
  SMIInput<bool>? _onTapInput;
  SMIInput<bool>? _isClosingInput;
  Artboard? _signUpAnimationArtboard;

  void onTap() {
    _isClosingInput!.value = false;
    _onTapInput!.value = true;
    if (!_onTapInput!.value && !_onTapInput!.controller.isActive) {
      _onTapInput!.controller.isActive = true;
    } else if (_onTapInput!.value && !_onTapInput!.value) {
      _onTapInput!.controller.isActive = false;
    }
  }

  void onClose() {
    _isClosingInput!.value = true;
    if (!_isClosingInput!.value && !_isClosingInput!.controller.isActive) {
      _isClosingInput!.controller.isActive = true;
    } else if (_isClosingInput!.value && !_isClosingInput!.value) {
      _isClosingInput!.controller.isActive = false;
    }
  }

  @override
  void dispose() {
    onClose();
    _signUpAnimationArtboard!.clearDependencies();
    super.dispose();
  }

  void initAssets() {
    rootBundle
        .load('assets/images_and_animations/signup_page/signUpAnimation.riv')
        .then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'SignUpAnimation');

        if (controller != null) {
          artboard.addController(controller);
          _onTapInput = controller.findInput('onTap');
          _isClosingInput = controller.findInput('isClosing');
        }
        setState(
          () {
            _signUpAnimationArtboard = artboard;
          },
        );
      },
    );
  }

  @override
  void initState() {
    initAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.0,
      width: 250.0,
      child: GestureDetector(
        onTap: () => onTap(),
        onDoubleTap: () => onClose(),
        child: _signUpAnimationArtboard == null
            ? const SizedBox()
            : Rive(
                fit: BoxFit.fitHeight,
                artboard: _signUpAnimationArtboard!,
              ),
      ),
    );
  }
}
