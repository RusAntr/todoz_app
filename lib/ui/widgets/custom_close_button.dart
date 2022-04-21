import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/constants.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size(30.0, 30.0),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(20.0, 20.0),
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.black.withOpacity(0.1),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.lightGray),
      ),
      onPressed: () => Get.back(),
      child: Icon(
        EvaIcons.close,
        color: Colors.black.withOpacity(0.5),
        size: 15.0,
      ),
    );
  }
}
