import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//this file contains all the global variables
FirebaseFirestore firestore = FirebaseFirestore.instance;

class Drawerclass {
  static bool showMenu = false;
}

class Authcheck {
  static String process = 'login';
}

final grey = const Color(0xFFe0e3e3).withOpacity(0.5);

double? height;
double? width;
void media(BuildContext context) {
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
}

const String _heroAddTodo = 'add-todo-hero';
const String _heroDoubt = 'doubt';
TextEditingController message = TextEditingController();
TextEditingController messageTitle = TextEditingController();
TextEditingController messageDescription = TextEditingController();
String? type;
String? role;
String? imageUrl;
String? docId;
const String? meetlink = "https://meet.google.com/wax-ncmq-eim";
String? to;
int? id;

TextEditingController nameController = TextEditingController();
TextEditingController yearController = TextEditingController();
TextEditingController divController = TextEditingController();
TextEditingController branchController = TextEditingController();
TextEditingController rollController = TextEditingController();

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

TextEditingController nameControllerT = TextEditingController();
TextEditingController fyControllerT = TextEditingController();
TextEditingController syControllerT = TextEditingController();
TextEditingController tyControllerT = TextEditingController();
TextEditingController btechControllerT = TextEditingController();
TextEditingController seqControllerT = TextEditingController();

String? currentUser;
String? currentYear;
