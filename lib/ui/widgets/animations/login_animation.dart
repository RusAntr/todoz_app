import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LogInAnimation extends StatefulWidget {
  const LogInAnimation({Key? key}) : super(key: key);

  @override
  LogInAnimationState createState() => LogInAnimationState();
}

class LogInAnimationState extends State<LogInAnimation> {
  SMIInput<bool>? _onTapInput;
  SMIInput<bool>? _isClosingInput;
  Artboard? _logInAnimationArtboard;

  void onTap() {
    _isClosingInput!.value = false;
    _onTapInput!.value = true;
    if (_onTapInput!.value == false &&
        _onTapInput!.controller.isActive == false) {
      _onTapInput!.controller.isActive = true;
    } else if (_onTapInput!.value == true && _onTapInput!.value == false) {
      _onTapInput!.controller.isActive = false;
    }
  }

  void onClose() {
    _isClosingInput!.value = true;
    if (_isClosingInput!.value == false &&
        _isClosingInput!.controller.isActive == false) {
      _isClosingInput!.controller.isActive = true;
    } else if (_isClosingInput!.value == true &&
        _isClosingInput!.value == false) {
      _isClosingInput!.controller.isActive = false;
    }
  }

  @override
  void dispose() {
    onClose();
    _logInAnimationArtboard!.clearDependencies();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    rootBundle
        .load('assets/images_animations/login_page/logInAnimation.riv')
        .then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'LogInAnimation');

        if (controller != null) {
          artboard.addController(controller);
          _onTapInput = controller.findInput('onTap');
          _isClosingInput = controller.findInput('isClosing');
        }
        setState(
          () {
            _logInAnimationArtboard = artboard;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: GestureDetector(
        onTap: () => onTap(),
        onDoubleTap: () => onClose(),
        child: _logInAnimationArtboard == null
            ? const SizedBox()
            : Rive(
                fit: BoxFit.fitHeight,
                artboard: _logInAnimationArtboard!,
              ),
      ),
    );
  }
}