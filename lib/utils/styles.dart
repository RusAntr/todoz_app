import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
//TextStyles
  final TextStyle textStyleTitle = GoogleFonts.poppins(
      color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600);

  final TextStyle textStyleWhiteText = GoogleFonts.poppins(
      color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal);

  final TextStyle textStyleProgress = GoogleFonts.poppins(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600);

  final TextStyle textStyleWhiteBigText = GoogleFonts.poppins(
      color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600);

  final TextStyle textStyleBlackBigText = GoogleFonts.poppins(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);

  final TextStyle textStyleToDoUndoneText = GoogleFonts.poppins(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600);

  final TextStyle textStyleToDoDoneText = GoogleFonts.poppins(
      decoration: TextDecoration.lineThrough,
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600);

  final TextStyle textStyleDoneText = GoogleFonts.poppins(
      color: Colors.black.withOpacity(0.4),
      fontSize: 11,
      fontWeight: FontWeight.normal);

  final TextStyle textStyleSmallGreenText = GoogleFonts.poppins(
      color: const Color(0xFF84E563),
      fontSize: 11,
      fontWeight: FontWeight.w600);

  final TextStyle textStyleSmallRedText = GoogleFonts.poppins(
      color: const Color(0xFFE56363),
      fontSize: 11,
      fontWeight: FontWeight.w600);
}