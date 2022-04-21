import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AppInputDecoarations {
  static const InputDecoration signUpTextField = InputDecoration(
    contentPadding: EdgeInsets.all(20.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.accentPurple,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: .0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: .0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    ),
    prefixIcon: Icon(
      EvaIcons.lockOutline,
      color: Colors.black,
    ),
    hintStyle: TextStyle(fontSize: 15.0),
  );

  static const InputDecoration createTodoTextField = InputDecoration(
    contentPadding: EdgeInsets.all(17.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: .0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          100.0,
        ),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: .0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    ),
    filled: true,
    fillColor: AppColors.lightGray,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: .0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    ),
    hintStyle: TextStyle(fontSize: 15.0),
  );
}
