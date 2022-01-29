import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoz_app/controllers/auth_controller.dart';

class LogIn extends GetWidget<AuthController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF6E4AFF),
      body: ListView(physics: const ClampingScrollPhysics(), children: [
        // Obx(() {
        //   return Text('Stared Count: ${Get.find<AuthController>().user}');
        // }),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height / 30),
            Image.asset(
              'assets/images/login_page/drawing_hand.png',
              height: height / 4,
            ),
            SizedBox(height: height / 40),
            Text('Welcome Back!',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: height / 40),
            //Email and Password Fields
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Address',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: height / 100),
                  TextField(
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    controller: _emailController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(17),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFB2CCFF), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        hintText: 'your email goes here',
                        prefixIcon: Icon(
                          EvaIcons.emailOutline,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(fontSize: 15)),
                  ),
                  SizedBox(height: height / 40),
                  Text(
                    'Password',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: height / 100),
                  TextField(
                    obscureText: true,
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(17),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFB2CCFF), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        hintText: 'your password goes here',
                        prefixIcon: Icon(
                          EvaIcons.lockOutline,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            //Log in Button
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.fromLTRB(45, 16, 45, 16)),
                    side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Color(0xFF6E4AFF))),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                onPressed: () => controller.login(
                    _emailController.text, _passwordController.text),
                child: Text(
                  'Log in',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )),
          ],
        ),
      ]),
    );
  }
}
