import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immence/resources/routes.dart';
import 'package:immence/resources/string_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cuser = FirebaseAuth.instance.currentUser;
    print('${cuser!.email}');

    return Scaffold(
      body: ListView(
        children: <Widget>[
          circleDesign(size: size),
          FutureBuilder<UserData?>(
              future: readUser(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.hasData) {
                  final user = snapshot.data;
                  return user == null
                      ? const Center(child: Text('No User'))
                      : buildUser(user);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const Text('null');
              }),
        ],
      ),
    );
  }

  Widget buildUser(UserData user) => Column(
        children: [
          Text(
            '${user.name}',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          profileData(
              title: StringResources.emailText, data: user.email as String),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          profileData(data: '+91 ${user.phoneNo}', title: 'Phone No.'),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Logout',
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () async {
                    final cuser = FirebaseAuth.instance.currentUser;
                    final docUser = FirebaseFirestore.instance
                        .collection('users')
                        .doc(cuser!.email);
                    try {
                      await FirebaseAuth.instance.signOut().then((_) {
                        docUser.update({
                          'login': false,
                        });
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      });
                      final sp = await SharedPreferences.getInstance();
                      sp.remove('email');
                    } catch (e) {
                      showErrorDialog(context, e.toString());
                    }
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      );

  Stream<List<UserData>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserData.fromJson(doc.data())).toList());

  Future<UserData?> readUser() async {
    final cuser = FirebaseAuth.instance.currentUser;
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(cuser!.email);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
  }
}

class profileData extends StatelessWidget {
  profileData({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);
  String data;
  String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                data,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 18,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class circleDesign extends StatelessWidget {
  const circleDesign({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.3,
      width: double.infinity,
      child: Center(
        child: Container(
          height: 175,
          width: 175,
          decoration:
              BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
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
