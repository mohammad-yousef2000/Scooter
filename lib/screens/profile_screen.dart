// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final _newP = TextEditingController();

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Center(
        child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Hello ${user.displayName ?? 'no name'}",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
          ),

          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              // controller: _emailController,
              initialValue: "${user.email}",

              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                label: Text(
                  "Email",
                  style: TextStyle(fontSize: 20),
                ),
                enabled: false,
              ),
            ),
          ),

          SizedBox(
            height: 110,
          ),
          const Divider(
            thickness: 1, // thickness of the line
            indent: 20, // empty space to the leading edge of divider.
            endIndent: 20, // empty space to the trailing edge of the divider.
            color:
                Colors.deepPurple, // The color to use when painting the line.
            height: 20,
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'In case you forgot your password change it below',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),

          //confirm pass
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                obscureText: true,
                controller: _newP,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.deepPurple)),
                    labelText: 'New Password',
                    fillColor: Theme.of(context).primaryColor,
                    filled: true),
              )),
          SizedBox(
            height: 30,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () async {
                if (_newP.value.text.length < 8 && _newP.value.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: 'Cant be empty or less than 8 characters',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (_newP.value.text.isNotEmpty &&
                    _newP.value.text.length >= 8) {
                  FirebaseAuth.instance.currentUser!.updatePassword(_newP.text);
                  Fluttertoast.showToast(
                      msg: 'Password updated',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  _newP.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                    child: Text(
                  "Update Password",
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
              ),
            ),
          ),

          SizedBox(
            height: 100,
          ),

          Align(
            alignment: FractionalOffset.bottomCenter,
            child: GestureDetector(
              onTap: () => FirebaseAuth.instance.signOut(),
              child: const Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ])),
      ),
    ));
  }
}
