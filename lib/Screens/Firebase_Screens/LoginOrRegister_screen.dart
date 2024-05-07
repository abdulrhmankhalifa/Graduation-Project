import 'package:flutter/material.dart';

import 'LoginF/login_screenF.dart';
import 'RegisterF/register_screenF.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreenF(onTap: togglePages);
    } else {
      return RegisterScreenF(onTap: togglePages);
    }
  }
}