// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, use_build_context_synchronously, non_constant_identifier_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var confirmPass;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _ageController.dispose();
    _confPasswordController.dispose();
  }

  Future signUp() async {
    final isvalid = formKey.currentState!.validate();
    if (!isvalid) return;

    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
      addUserDetails(_firstNameController.text.trim(),
          _emailController.text.trim(), int.parse(_ageController.text.trim()));
      Navigator.of(context).pop();
      User? user = result.user;
      if (user != null) {
        user.updateDisplayName(_firstNameController.text);
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Email already exist',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pop();
    }
  }

  Future addUserDetails(
    String name,
    String email,
    int age,
  ) async {
    await FirebaseFirestore.instance.collection("Users").add({
      'name': name,
      'email': email,
      'age': age,
    });
  }

  bool PasswordConf() {
    if (_passwordController.text.trim() ==
        _confPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //hello again

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Register below",
                      style: GoogleFonts.bebasNeue(fontSize: 44),
                    ),
                  ),
                  const SizedBox(height: 50),
                  //full name text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Full Name",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (Fname) {
                        if (Fname != null && Fname.isEmpty) {
                          return 'Cant be empty';
                        } else if (Fname != null && Fname.length <= 4) {
                          return "bad format";
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //age text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _ageController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Age",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (Age) {
                        if (Age != null && Age.isEmpty) {
                          return 'Cant be empty';
                        } else if (int.parse(Age!) < 18) {
                          return "Age should be 18 or higher ";
                        } else if (Age != null && int.parse(Age) > 50) {
                          return 'Age restricted';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //email text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Email",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //password tex
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                            hintText: 'Password',
                            fillColor: Colors.grey[200],
                            filled: true),
                        validator: (value) {
                          confirmPass = value;
                          if (value!.isEmpty) {
                            return "Please Enter New Password";
                          } else if (value.length < 8) {
                            return "Password must be atleast 8 characters long";
                          } else {
                            return null;
                          }
                        },
                      )),
                  const SizedBox(
                    height: 10,
                  ),

                  //confirm pass
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: _confPasswordController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                            hintText: 'Confirm Password',
                            fillColor: Colors.grey[200],
                            filled: true),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Re-Enter New Password";
                          } else if (value.length < 8) {
                            return "Password must be atleast 8 characters long";
                          } else if (value != confirmPass) {
                            return "Password must be same as above";
                          } else {
                            return null;
                          }
                        },
                      )),
                  const SizedBox(
                    height: 10,
                  ),

                  //sign in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                            child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //not a member
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          " Log In now",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
