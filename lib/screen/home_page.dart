import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immence/screen/login_page.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as dev;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          final user = FirebaseAuth.instance.currentUser;
          dev.log('$user');
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return LoginPage();
              break;

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
