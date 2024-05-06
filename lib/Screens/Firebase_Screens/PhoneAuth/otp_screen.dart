import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Sheard/component.dart';

class OTPScreen extends StatefulWidget {
  String verificationid;
  OTPScreen({
    super.key,
    required this.verificationid,
  });


  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset('images/BMSK.png'),
                iconSize: 200,
                onPressed: () {
                },
                color: Colors.grey[800],
              ),

              const Text(
                'Check Your mobile to get verification code',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 15.0,),
              MyTextField(
                controller: otpController,
                hintText: 'Enter The OTP',
                obscureText: false,
              ),
              const SizedBox(height: 15.0,),
              MyButton(
                  onTap: () async {
                    try{
                      PhoneAuthCredential credential =
                          await PhoneAuthProvider
                          .credential(
                          verificationId: widget.verificationid,
                          smsCode: otpController.text.toString(),
                      );
                      FirebaseAuth.instance.signInWithCredential(credential)
                          .then((value){
                           Navigator.pop(context);
                           });
                    } catch (ex) {
                      log(ex.toString() as num,);
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
