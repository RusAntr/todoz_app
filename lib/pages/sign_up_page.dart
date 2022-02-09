import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/pages/log_in_page.dart';

class SignUp extends GetWidget<AuthController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF6E4AFF),
        body: ListView(physics: const ClampingScrollPhysics(), children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height / 30),
              Image.asset(
                'assets/images/signup_page/two_hands_meet.png',
                width: width / 1.3,
              ),
              SizedBox(height: height / 40),
              Text('Let\'s Get Started!',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: height / 40),
              //Email, Name and Password Fields
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: height / 100),
                    TextField(
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w400),
                      controller: _nameController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(17.0),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFB2CCFF), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: .0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: .0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          hintText: 'your name goes here',
                          prefixIcon: Icon(
                            EvaIcons.personOutline,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(fontSize: 15.0)),
                    ),
                    SizedBox(height: height / 40),
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: height / 100.0),
                    TextField(
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w400),
                      controller: _emailController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(17.0),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFB2CCFF), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: .0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: .0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          hintText: 'your email goes here',
                          prefixIcon: Icon(
                            EvaIcons.emailOutline,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(fontSize: 15.0)),
                    ),
                    SizedBox(height: height / 40.0),
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: height / 100.0),
                    TextField(
                      obscureText: true,
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w400),
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(17.0),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFB2CCFF), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: .0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: .0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          hintText: 'your password goes here',
                          prefixIcon: Icon(
                            EvaIcons.lockOutline,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(fontSize: 15.0)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height / 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Sign Up with Google Button
                    TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          EvaIcons.google,
                          color: Colors.blue,
                        ),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(
                                    15.0, 14.0, 15.0, 14.0)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(100.0)))),
                        label: Text(
                          'Sign up with Google',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        )),
                    //Sign Up Button
                    TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(
                                    35.0, 16.0, 35.0, 16.0)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(100.0))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          controller.createUser(_nameController.text,
                              _emailController.text, _passwordController.text);
                        },
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: height / 30.0,
              ),
              Text(
                'Already have an account?',
                style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: height / 100.0,
              ),
              //Log in Button
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(45.0, 16.0, 45.0, 16.0)),
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Color(0xFF6E4AFF))),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0))),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.5))),
                  onPressed: () => Get.to(LogIn()),
                  child: Text(
                    'Log in',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  )),
            ],
          ),
        ]),
      ),
    );
  }
}