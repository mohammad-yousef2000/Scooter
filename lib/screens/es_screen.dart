// ignore_for_file: prefer_const_constructors, camel_case_types, unused_import, deprecated_member_use, prefer_final_fields, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, sort_child_properties_last, non_constant_identifier_names

import 'dart:async';

import 'package:finalfb/screens/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

class esPage extends StatefulWidget {
  const esPage({super.key});

  @override
  State<esPage> createState() => _esPageState();
}

class _esPageState extends State<esPage> {
  String Speed = '';
  DatabaseReference _speed = FirebaseDatabase.instance.ref();
  late StreamSubscription _DStream;

  @override
  void initState() {
    super.initState();
    _activateListner();
  }

  void _activateListner() {
    _DStream = _speed.child('Scooter 01/speed').onValue.listen((event) {
      final Object? desc = event.snapshot.value;
      setState(() {
        Speed = "Speed:$desc";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Scooter Page"),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: ListView(children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/es2.jpg',
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                child: Text(
                  "${Speed}",
                  style: TextStyle(fontSize: 40),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 250,
              ),
              ElevatedButton(
                onPressed: () {
                  _speed.update({'Scooter 01/rented': false});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavScreen()));
                },
                child: Text("Finish"),
              ),
            ]),
          )),
    );
  }

  @override
  void deactivate() {
    _DStream.cancel();
    super.deactivate();
  }
}
