// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/profile_screen.dart';

class Userr {
  final String uid;

  Userr({required this.uid});

  final usercollection = FirebaseFirestore.instance.collection("Users");

  Future UpdateUserInfo(String name, String age) async {
    return await usercollection.doc(uid).set({
      "name": name,
      "age": age,
    });
  }

  Stream<QuerySnapshot> get users {
    return usercollection.snapshots();
  }

  Future getCurrentUserData() async {
    try {
      DocumentSnapshot ds = await usercollection.doc(uid).get();
      String name = ds.get('name');
      String age = ds.get("age");
      return [name, age];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
