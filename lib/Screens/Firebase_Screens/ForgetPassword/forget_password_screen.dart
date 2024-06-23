import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Sheard/component.dart';
import '../../../Styles/colors.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future PasswordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! check your email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: defaultColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/LogoImage.jpg',
                      scale: 4,
                    ),
                    onPressed: () {},
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  const Text(
                      'Check your email and we will send you a password reset link'),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Enter Email',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  MyButton(
                    onTap: PasswordReset,
                    text: "Reset Password",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
