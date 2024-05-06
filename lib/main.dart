import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';
import 'Network/auth_gate.dart';
import 'Network/auth_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

///"tam"
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return  const MaterialApp(
      home:  AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}