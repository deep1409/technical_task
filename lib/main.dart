import 'package:flutter/material.dart';
import 'package:immence/screen/home_page.dart';
import 'package:immence/screen/login_page.dart';
import 'package:immence/screen/profile_page.dart';
import 'package:immence/screen/sign_up_page.dart';
import './resources/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Immence Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (ctx)=> const LoginPage(),
        profileRoute: (ctx)=> const ProfilePage(),
        signupRoute: (ctx)=> const SignUpPage(),
        homePageRoute: (ctx)=> const HomePage(),
      },
    );
  }
}






