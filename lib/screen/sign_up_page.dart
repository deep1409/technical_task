import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:immence/resources/string_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:developer' as dev;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneNoController;
  TextEditingController? passwordController;
  final _nameFoucsnode = FocusNode();
  final _emailFoucsnode = FocusNode();
  final _phonenoFoucsnode = FocusNode();
  final _passFoucsnode = FocusNode();
  bool? passwordVisibility;
  bool value = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    phoneNoController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility = false;
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
              const SizedBox(
                height: 20,
              ),
              Text(
                StringResources.companyName,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                StringResources.createAccountText,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue[900],
                  // fontWeight: FontWeight,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        StringResources.nameText,
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
                        controller: nameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: StringResources.nameHintText,
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        StringResources.emailAddressText,
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
                        controller: emailController,
                        obscureText: false,
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        StringResources.phoneNumber,
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
                        controller: phoneNoController,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: StringResources.phoneNumberHintText,
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
                      height: 10,
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
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: signUp,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading == false
                            ? const Text(
                                StringResources.signUpText,
                                textScaleFactor: 1.0,
                                style: TextStyle(color: Colors.white),
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
                height: size.height * 0.12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringResources.alreadyhaveaccText,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    },
                    child: Text(
                      StringResources.loginText,
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

  Future<void> signUp() async {
    dev.log('name: ${nameController!.text}\n'
        'email: ${emailController!.text}\n'
        'phone no.: ${phoneNoController!.text}\n'
        'password: ${passwordController!.text}');

    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController!.text) ||
        passwordController!.text.isEmpty ||
        passwordController!.text.length < 6 || !RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(phoneNoController!.text) ||  nameController!.text.isEmpty) {
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
      final name = nameController!.text;
      final phoneNo = phoneNoController!.text;
      final password = passwordController!.text;
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          // name: name,
          email: email,
          password: password,
        );
        if(value){
          final sp = await SharedPreferences.getInstance();
          Map<String, dynamic> data = {
            'email': email,
            'password': password
          };
          sp.setString('email', jsonEncode(data));
          print('${sp.getString('email')}');
        }

        final user = FirebaseAuth.instance.currentUser;
        await user?.updateDisplayName(name);
        final docUser = FirebaseFirestore.instance.collection('users').doc(email);
        final json = {
          'email': email,
          'name': name,
          'login': true,
          'phonenumber': int.parse(phoneNo),
        };
        await docUser.set(json);

        // await user.updatePhoneNumber(phoneCredential);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(profileRoute, (route) => false);
        stopLoading();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          stopLoading();
          showErrorDialog(
            context,
            'Weak Password',
          );
        } else if (e.code == 'email-already-in-use') {
          stopLoading();
          showErrorDialog(
            context,
            'Email is already in use',
          );
        } else if (e.code == 'invalid-email') {
          stopLoading();
          showErrorDialog(
            context,
            'This is an invalid email address',
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
