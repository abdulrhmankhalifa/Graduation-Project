import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Styles/colors.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> changePassword() async {
    try {
      final cred = EmailAuthProvider.credential(
          email: currentUser!.email!, password: oldPasswordController.text);
      await currentUser!.reauthenticateWithCredential(cred);
      await currentUser!.updatePassword(newPasswordController.text);
      print("Password Changed Successfully");
      // Optionally show a success dialog to the user
    } on FirebaseAuthException catch (error) {
      String message = "";
      switch (error.code) {
        case "wrong-password":
          message = "The old password is incorrect.";
          break;
        case "weak-password":
          message = "The new password is too weak.";
          break;
        case "email-already-in-use":
          message = "The email is already in use by another account.";
          break;
        default:
          message = "An error occurred: ${error.code}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      print("An unexpected error occurred: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("An unexpected error occurred. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: defaultColor, // Change your color here
        ),
        title: const Center(
          child: Text(
            'Change Password',
            style: TextStyle(
              fontSize: 22.0,
              color: defaultColor,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/LogoImage.jpg'),
                  iconSize: 170,
                  onPressed: () {},
                  color: Colors.grey[800],
                ),
                 SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'It is recommended to use a strong password',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                 SizedBox(
                  height: screenHeight * 0.01,
                ),
                TextFormField(
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    isDense: true,
                    alignLabelWithHint: true,
                    labelText: 'Enter Your Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                 SizedBox(
                  height: screenHeight * 0.03,
                ),
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Enter A New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                 SizedBox(
                  height: screenHeight * 0.03,
                ),
                TextFormField(
                  controller: confirmNewPasswordController,
                  decoration: const InputDecoration(
                    isDense: false,
                    labelText: 'Enter A New Password Again',
                    border: OutlineInputBorder(),
                  ),
                ),
                 SizedBox(
                  height: screenHeight * 0.03,
                ),
                GestureDetector(
                  onTap: () async {
                    changePassword();
                    if (newPasswordController.text.trim() !=
                        confirmNewPasswordController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("New passwords do")));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                 SizedBox(
                  height: screenHeight * 0.01,
                ),
                const Text(
                  'Password must be at least 6 characters',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
