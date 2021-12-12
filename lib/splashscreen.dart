import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/home.dart';
import 'package:mentor_mate/welcome_and_other.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _versionName = 'V1.0';
  final splashDelay = 4;
  var userMap;

  @override
  void initState() {
    super.initState();
    //isUserLoggedIn();
    _loadWidget();
  }

  _loadWidget() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) async {
          setState(() {
            role = value.get('role');
            userMap = value.data();
            currentName = value.get('name');
          });
        });
      } catch (e) {
        try {
          await FirebaseFirestore.instance
              .collection('teachers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) async {
            setState(() {
              role = value.get('role');
              userMap = value.data();
            });
          });
        } catch (e) {
          print('Error loading user');
        }
      }

      var _duration = Duration(seconds: splashDelay);
      return Timer(_duration, navigationPageloggedIn);
    } else {
      var _duration = Duration(seconds: splashDelay);
      return Timer(_duration, navigationPage);
    }
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => Welcome()));
  }

  void navigationPageloggedIn() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      if (role == 'student') {
        return StudentHome(userMap: userMap);
      } else {
        return TeacherHome(teacherMap: userMap);
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    media(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: height * 0.07, //60
                          child: Center(
                              child: SvgPicture.asset('assets/logo.svg'))),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          minHeight: 2,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Spacer(),
                            Text(_versionName),
                            Spacer(
                              flex: 4,
                            ),
                            Text('androing'),
                            Spacer(),
                          ])*/
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
