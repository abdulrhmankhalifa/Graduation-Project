import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/Firebase_Screens/LoginOrRegister_screen.dart';
import '../Screens/HomePage/home_page.dart';



class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context , snapshot){
          ///User Logged in
          if(snapshot.hasData){
            return const HomeDesign();
          }
          /// User is not logged in
          else{
            return const LoginOrRegister();
          }
        }
      ),
    );
  }
}
