import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentor_mate/authentication/login.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/components/loader.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/home.dart';

/*class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return StudentHome();
    } else {
      return Login();
    }
  }
}*/

Future<User?> createAccount(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Account Created Successful");
      return user;
    } else {
      print("Account Creation Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    // ignore: unnecessary_null_comparison
    if (user != null) {
      print("Login Successful");
      return user;
    } else {
      print("Login Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  } catch (e) {
    print("error");
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
Map<String, dynamic>? userMap;

void addUserData() async {
  if (nameController.text.isNotEmpty &&
      branchController.text.isNotEmpty &&
      divController.text.isNotEmpty &&
      yearController.text.isNotEmpty &&
      rollController.text.isNotEmpty) {
    print(message.text);
    id = Random().nextInt(100000);

    Map<String, dynamic> userData = {
      'email': email.text,
      "name": nameController.text,
      'year': yearController.text,
      'branch': branchController.text,
      'div': divController.text,
      "roll": rollController.text,
      'role': role,
      'messageId': id,
      'uid': auth.currentUser!.uid,
      "status": "Unavailable",
      "timestamp": FieldValue.serverTimestamp().toString(),
      "time": DateTime.now().hour,
      "istyping": false,
      "recent": "no messages",
      "touser": "noid",
      'id':
          '${nameController.text} ${yearController.text} ${branchController.text} ${divController.text} ${rollController.text}'
    };

    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .update(userData);
  } else {
    print('Enter Some Text');
  }
}

void addTeacher() async {
  if (nameControllerT.text.isNotEmpty && role!.isNotEmpty) {
    Map<String, dynamic> teacherData = {
      'email': email.text,
      "name": nameControllerT.text,
      'FY': fyControllerT.text,
      'SY': syControllerT.text,
      'TY': tyControllerT.text,
      "BTech": btechControllerT.text,
      'role': role,
    };

    await _firestore
        .collection('teachers')
        .doc(_auth.currentUser!.uid)
        .set(teacherData);
  } else {
    print('Enter Some Text');
  }
}
