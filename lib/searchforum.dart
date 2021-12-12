// import 'package:cloud_firestore/cloud_firestore.dart';
// import "package:flutter/material.dart";

// class Datamodel{
//     final String name;
//   final String description;
//   Datamodel({required this.name,required this.description});
//   List<Datamodel> (QuerySnapshot querySnapshot) {
//     return querySnapshot.docs.map((snapshot) {
//       final Map<String, dynamic> dataMap = snapshot.data.docs;

//       return Datamodel(
//           name: dataMap['title'], description: dataMap['description']);
//     }).toList();
//   }
// }
