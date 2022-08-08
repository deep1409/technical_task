import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immence/resources/string_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  final formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  bool? passwordVisibility;
  bool value = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Container(
                height: size.height * 0.25,
                child: Center(
                  child: Text(
                    StringResources.companyName,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 65,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Text(
                StringResources.welcomText,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        StringResources.emailText,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: TextField(
                        focusNode: _emailFocusNode,
                        controller: emailController,
                        obscureText: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: StringResources.emailHintText,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFDBE2E7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFDBE2E7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        StringResources.passwordText,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: TextField(
                        focusNode: _passFocusNode,
                        controller: passwordController,
                        obscureText: !passwordVisibility!,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            hintText: StringResources.passwordHintText,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFDBE2E7),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFDBE2E7),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: InkWell(
                              onTap: () => setState(
                                () => passwordVisibility = !passwordVisibility!,
                              ),
                              child: Icon(
                                passwordVisibility!
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Row(
                      children: [
                        Checkbox(
                          value: value,
                          onChanged: (value) {
                            setState(() {
                              this.value = value!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              value = !value;
                            });
                          },
                          child: const Text(
                            StringResources.rememberMeText,
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading == false
                            ? const Text(
                                StringResources.loginText,
                                textScaleFactor: 1.0,
                              )
                            : const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringResources.donthaveaccText,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          signupRoute, (route) => false);
                    },
                    child: Text(
                      StringResources.signUpText,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(emailController!.text);
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController!.text) ||
        passwordController!.text.isEmpty ||
        passwordController!.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            StringResources.snackbarLoginText,
          ),
        ),
      );
    } else {
      startLoading();
      final email = emailController!.text;
      final password = passwordController!.text;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        docUser.update({
          'login': true,
        });
        if(value){
          final sp = await SharedPreferences.getInstance();
          Map<String, dynamic> data = {
            'email': email,
            'password': password
          };
          sp.setString('email', json.encode(data));
          print('${sp.getString('email')}');
        }
        final user = FirebaseAuth.instance.currentUser;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(profileRoute,(route) => false);
        stopLoading();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          stopLoading();
          showErrorDialog(
            context,
            'User not found',
          );
        } else if (e.code == 'wrong-password') {
          stopLoading();
          showErrorDialog(
            context,
            'Wrong credentials',
          );
        } else {
          stopLoading();
          showErrorDialog(
            context,
            '${e.code}',
          );
          // devtools.log('Something wrong happen!!');
        }
      } catch (e) {
        stopLoading();
        showErrorDialog(
          context,
          '$e',
        );
      }
    }
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('An error occurred'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
}
