import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Sheard/component.dart';

// ignore: must_be_immutable
class OTPScreen extends StatefulWidget {
  String verificationid;
  final void Function() signUpWithEmailandPassword;

  OTPScreen({
    super.key,
    required this.verificationid,
    required this.signUpWithEmailandPassword,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/images/LogoImage.jpg',
                  scale: 4,
                ),
                onPressed: () {},
                color: Colors.white,
              ),
              const Text(
                'Check Your mobile to get verification code',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              MyTextField(
                controller: otpController,
                hintText: 'Enter The OTP',
                obscureText: false,
              ),
              const SizedBox(
                height: 15.0,
              ),
              MyButton(
                onTap: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: widget.verificationid,
                      smsCode: otpController.text.trim(),
                    );
                    await FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) async {
                      // Create a new account in Firebase only when OTP verification is successful
                      widget.signUpWithEmailandPassword();
                      Navigator.pop(context);
                    });
                  } catch (ex) {
                    log(
                      ex.toString() as num,
                    );
                  }
                },
                text: "OTP",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
