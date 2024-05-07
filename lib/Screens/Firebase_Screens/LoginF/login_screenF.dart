import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Network/auth_service.dart';
import '../../../Sheard/component.dart';
import '../ForgetPassword/forget_password_screen.dart';

class LoginScreenF extends StatefulWidget {
  final void Function()? onTap;

  const LoginScreenF({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginScreenF> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreenF> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ///Sign in user
  void signIn() async {
    /// get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text , passwordController.text,

      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
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
                      scale: 5,
                    ),
                    onPressed: () {},
                    color: Colors.white,
                  ),
                  const Text(
                    "Welcome back you\'ve been missed!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                   SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                   SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                   SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ForgetPasswordPage();
                          }));
                        },
                        child: const Text(
                          'Forget Password!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  MyButton(
                    onTap: signIn,
                    text: "Sign In",
                  ),
                   SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member?'),
                       SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
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
