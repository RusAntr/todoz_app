import 'dart:ui';

class AppColors {
  static const lightGray = Color(0xffF2F4F5);

  static const darkPurple = Color(0xff5C39E7);
  static const mainPurple = Color(0xff6E4AFF);
  static const accentPurple = Color(0xffC4B5FF);
  static const lightPurple = Color(0xffEBE4FF);

  static const mainGreen = Color(0xFF84E563);
  static const accentGreen = Color(0xFFDFFFD4);

  static const mainRed = Color(0xFFE56363);
  static const accentRed = Color(0xFFFFD4D4);

  static const accentBlue = Color(0xFFEFF0FA);

  static const projectOrange = Color(0xffF7AD78);
  static const projectBlue = Color(0xff78A3F7);
  static const projectPurple = Color(0xffC790FF);
  static const projectRed = Color(0xffFF7C7C);
  static const projectGreen = Color(0xff79E397);
  static const projectGray = Color(0xffB3C7C6);
  static const projectPink = Color(0xffFD84B7);

  Color getColor(String source) => Color(int.parse(source));
}
