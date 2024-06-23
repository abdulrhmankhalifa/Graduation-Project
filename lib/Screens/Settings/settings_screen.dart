import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../Network/auth_service.dart';
import '../../Styles/colors.dart';
import 'inSettings/change_password.dart';
import 'inSettings/myaccount_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    void signOut() {
      /// get auth service
      /// get auth service
      final authService = Provider.of<AuthService>(context, listen: false);

      authService.signOut();
    }

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.2,
              ),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 25.0,
                  color: defaultColor,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyAccountScreen();
                  }));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'My Account',
                      style: TextStyle(color: defaultColor, fontSize: 15.0),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: defaultColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ChangePasswordScreen();
                  }));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(color: defaultColor, fontSize: 15.0),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: defaultColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  signOut();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Log Out',
                      style: TextStyle(color: defaultColor, fontSize: 15.0),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: defaultColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
