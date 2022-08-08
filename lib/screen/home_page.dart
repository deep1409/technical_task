import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immence/screen/login_page.dart';
import 'package:immence/screen/profile_page.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? finalData;

  @override
  void initState() {
    checkPref();
    super.initState();
  }

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
              return finalData == null ? const LoginPage() : const ProfilePage();
              break;

            default:
              return const CircularProgressIndicator();
          }
        });
  }

  Future<void> checkPref() async {
    final sp = await SharedPreferences.getInstance();
    var getData = sp.getString('email');
    setState(() {
      finalData = getData as String;
    });
    print(finalData);
  }
}
