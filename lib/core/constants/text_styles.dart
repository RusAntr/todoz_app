import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTextStyles {
  static final TextStyle whiteHeader = GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle blackHeader = GoogleFonts.poppins(
    color: Colors.black,
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle whiteTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 15,
  );

  static final TextStyle whiteTitleBold =
      whiteTitle.copyWith(fontWeight: FontWeight.w600);

  static final TextStyle whiteTitleNormal =
      whiteTitle.copyWith(fontWeight: FontWeight.w400);

  static final TextStyle blackTitleNormal = GoogleFonts.inter(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle textStyleTitle = GoogleFonts.inter(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle noTasksToDo = GoogleFonts.inter(
      color: Colors.black.withOpacity(0.2),
      fontSize: 18,
      fontWeight: FontWeight.normal);

  static final TextStyle dateTimeItem = GoogleFonts.inter(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal);

  static final TextStyle textStyleNoProjects = GoogleFonts.inter(
      color: Colors.black.withOpacity(0.3),
      fontSize: 15,
      fontWeight: FontWeight.w600);

  static final TextStyle textStyleWhiteText = GoogleFonts.inter(
      color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal);

  static final TextStyle numberOfTasksLabelProductivity = GoogleFonts.inter(
      color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal);

  static final TextStyle numberOfTasksProductivity = GoogleFonts.inter(
      color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600);

  static final TextStyle textStyleProjectChipText = GoogleFonts.inter(
      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600);

  static final TextStyle textStyleTodoWidgetDateWhite = GoogleFonts.inter(
      color: Colors.white.withOpacity(0.5),
      fontSize: 13,
      fontWeight: FontWeight.normal);

  static final TextStyle textStyleTodoWidgetDateBlack = GoogleFonts.inter(
      color: Colors.black.withOpacity(0.5),
      fontSize: 13,
      fontWeight: FontWeight.normal);

  static final TextStyle projectNameTodoCard = GoogleFonts.inter(
      color: Colors.black.withOpacity(0.3),
      fontSize: 11,
      fontWeight: FontWeight.normal);

  static final TextStyle projectNameProgressive = GoogleFonts.inter(
      color: Colors.black.withOpacity(0.3),
      fontSize: 10,
      fontWeight: FontWeight.normal);

  static final TextStyle textStyleProgress = GoogleFonts.inter(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);

  static final TextStyle textStyleProgressPreview = GoogleFonts.inter(
      color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600);

  static final TextStyle createNewTask = GoogleFonts.inter(
      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600);

  static final TextStyle doneVsUndoneProgressWidget = GoogleFonts.inter(
      color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600);

  static final TextStyle projectNameProjectCard = GoogleFonts.inter(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);

  static final TextStyle textStyleTodoNameWidgetBlack = GoogleFonts.inter(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);

  static final TextStyle textStyleTodoNameWidgetWhite = GoogleFonts.inter(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);

  static final TextStyle textStyleProjectName = GoogleFonts.inter(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);

  static final TextStyle textStyleProjectNamePreview = GoogleFonts.inter(
      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600);

  static final TextStyle textStyleBlackBigText = GoogleFonts.inter(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);

  static final TextStyle giantTitle = GoogleFonts.inter(
      color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold);

  static final TextStyle textStyleToDoUndoneText = GoogleFonts.inter(
      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600);

  static final TextStyle timePassedVsDuration = GoogleFonts.inter(
      color: Colors.black.withOpacity(0.3),
      fontSize: 11,
      fontWeight: FontWeight.normal);

  static final TextStyle todoContentProgressive = GoogleFonts.inter(
      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600);

  static final TextStyle textStyleBlackSmallText = GoogleFonts.inter(
      color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600);

  static final TextStyle textStyleToDoDoneText = GoogleFonts.inter(
      decoration: TextDecoration.lineThrough,
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w600);

  static final TextStyle textStyleAddTaskText = GoogleFonts.inter(
      color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500);

  static final TextStyle textStyleDoneText = GoogleFonts.inter(
      color: Colors.black.withOpacity(0.4),
      fontSize: 10,
      fontWeight: FontWeight.normal);

  static final TextStyle textStyleSmallGreenText = GoogleFonts.inter(
      color: AppColors.mainGreen, fontSize: 11, fontWeight: FontWeight.w600);

  static TextStyle textStyleSmallRedText = GoogleFonts.inter(
      color: AppColors.mainRed, fontSize: 11, fontWeight: FontWeight.w600);
}
