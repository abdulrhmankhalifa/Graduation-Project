import 'dart:convert';
import 'package:graduation_project_yarab/Styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../Network/auth_service.dart';
import '../../../Sheard/component.dart';
import '../PhoneAuth/otp_screen.dart';

class RegisterScreenF extends StatefulWidget {
  final void Function()? onTap;
  const RegisterScreenF({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterScreenF> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterScreenF> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  ///Sign up user
  // void signUp() async
  // {
  //   if (passwordController.text != confirmPasswordController.text){
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text("Password do  not match!"),
  //         ),
  //     );
  //   }else{
  //     await FirebaseAuth.instance
  //         .verifyPhoneNumber(
  //       verificationCompleted: (PhoneAuthCredential credential){
  //
  //       },
  //       verificationFailed: (FirebaseAuthException ex){
  //
  //       },
  //       codeSent: (String verificationid , int? resendtoken){
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => OTPScreen(verificationid: verificationid,)
  //             )
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (String verificationid){
  //
  //       },
  //       phoneNumber: phoneController.text.toString(),
  //     );
  //   }
  //
  //
  //
  //
  //
  //
  //
  //   ///get  auth service
  //   final authService = Provider.of<AuthService>(context, listen:  false);
  //
  //   try{
  //     await authService.signUpWithEmailandPassword(emailController.text,passwordController.text);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(e.toString(),
  //         ),
  //       ),
  //     );
  //   }
  //
  //
  // }

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password does not match!"),
        ),
      );
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential){

        },
        verificationFailed: (FirebaseAuthException ex){

        },
        codeSent: (String verificationid , int? resendtoken){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(verificationid: verificationid,)
              )
          );
        },
        codeAutoRetrievalTimeout: (String verificationid){

        },
        phoneNumber: phoneController.text.toString(),
      );

      /// Get auth service
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signUpWithEmailandPassword(
          emailController.text,
          passwordController.text,
        );

        // Get the user ID
        final userId = FirebaseAuth.instance.currentUser?.uid;

        // Make an API call to send the user ID
        // Replace with your actual API endpoint and data format
        await sendUserIdToApi(userId);

        // Navigate to the next screen (e.g., HomeScreen)
        // ...
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<void> sendUserIdToApi(String? userId) async {
    // Replace with your actual API endpoint and data format
    final apiUrl = 'https://graduation-project-nodejs.onrender.com/api/users/register';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firebaseId': userId,
      }),
    );

    if (response.statusCode == 200) {
      // API call successful
      print('User ID sent to API successfully');
    } else {
      // Handle API error
      print('Error sending user ID to API: ${response.statusCode}');
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///Icon app
                  IconButton(
                    icon: Image.asset(
                        'assets/images/LogoImage.jpg',
                      scale: 4,
                    ),
                    onPressed: () {},
                    color: Colors.white,
                  ),

                  ///Text
                  const Text(
                    "Let's create an account for you!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                   SizedBox(height: screenHeight * 0.02,),
                  ///EmailTextField
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),



                   SizedBox(height: screenHeight * 0.01,),

                  ///PasswordTextField
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  SizedBox(height: screenHeight * 0.01,),

                  ///ConfirmPasswordTextField
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  SizedBox(height: screenHeight * 0.01,),


                  /// PhoneNumberTextField
                  MyTextField(
                    controller: phoneController,
                    hintText: 'Phone number for verify',
                    obscureText: false,
                  ),

                  SizedBox(height: screenHeight * 0.01,),

                  ///button Sigh up Field
                  MyButton(
                    onTap: signUp,
                    text: "Sign Up",
                  ),

                  SizedBox(height: screenHeight * 0.01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already a member?'),
                       SizedBox(width:screenWidth * 0.02,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

