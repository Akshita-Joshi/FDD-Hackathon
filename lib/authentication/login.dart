import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentor_mate/authentication/authenticate.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/components/loader.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  double emailOpacity = 0.0;
  double passOpacity = 0.0;

  static TextStyle _hintText() {
    return TextStyle(
        fontFamily: "MontserratM",
        fontSize: width! * 0.061, //24
        color: Colors.black.withOpacity(0.3));
  }

  static TextStyle _inputText() {
    return TextStyle(
        fontFamily: "MontserratM",
        fontSize: width! * 0.061, //24
        color: Colors.black);
  }

  static AnimatedOpacity _label(double value, String text) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 120),
      opacity: value,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: "MontserratM",
              fontSize: width! * 0.035, //14
              color: Colors.black.withOpacity(0.3)),
        ),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  void _callOnTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(alignment: Alignment.center, children: [
        Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: height * 0.305, //260
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.9), BlendMode.srcOver),
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/3.jpg'))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.071), //28
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.065), //56
                      InkWell(
                        customBorder: new CircleBorder(),
                        splashColor: Colors.black.withOpacity(0.2),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: height * 0.035, //30
                            width: width * 0.076, //30
                            child: Center(
                                child: SvgPicture.asset('assets/back.svg'))),
                      ),
                      SizedBox(
                        height: height * 0.058, //50
                      ),
                      Text(
                        "Login ",
                        style: TextStyle(
                          fontFamily: "MontserratB",
                          fontSize: width * 0.112, //44
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.058), //50
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.071), //28
                  child: ListView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    //mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //field1("Email", _email),
                      //--------------------------------
                      _label(
                        emailOpacity,
                        "Email",
                      ),
                      TextFormField(
                        controller: _email,
                        style: _inputText(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: _hintText(),
                          hintText: "Email",
                        ),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? emailOpacity = 1 : emailOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          _callOnTop();
                        },
                      ),
                      SizedBox(height: height * 0.011), //10
                      //field2("Password", _password),
                      //--------------------------------
                      _label(passOpacity, "Password"),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        style: _inputText(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: _hintText(),
                            hintText: "Password"),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? passOpacity = 1 : passOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          _callOnTop();
                        },
                      ),
                      SizedBox(height: height * 0.011), //10

                      SizedBox(
                        height: height / 2 - (height * 0.35), //300
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: width * 0.254, //100
          bottom: height * 0.07, //60
          child: (_email.text.isNotEmpty && _password.text.isNotEmpty)
              ? AnimatedTextKit(
                  pause: Duration(milliseconds: 1500),
                  repeatForever: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Loader(
                                  message:
                                      'Please wait while we \nlog you in..',
                                )));
                    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                      logIn(_email.text, _password.text).then((user) async {
                        if (user != null) {
                          getUser();
                          var userMap;
                          var teacherMap;
                          role == 'student'
                              ? await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(auth.currentUser!.uid)
                                  .get()
                                  .then((value) {
                                  print(value.data());
                                  print(value.data()!['name']);
                                  currentUser = value.data()!['name'];
                                  setState(() {
                                    userMap = value.data()!;
                                  });
                                })
                              : await FirebaseFirestore.instance
                                  .collection("teachers")
                                  .doc(auth.currentUser!.uid)
                                  .get()
                                  .then((value) {
                                  print(value.data());
                                  print(value.data()!['name']);
                                  currentUser = value.data()!['name'];
                                  setState(() {
                                    teacherMap = value.data()!;
                                  });
                                });

                          print("Login Successful");
                          Fluttertoast.showToast(
                              msg: 'Logged In successfully',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: grey,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          role == 'student'
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          StudentHome(userMap: userMap)))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TeacherHome(
                                            teacherMap: teacherMap,
                                          )));
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          print("Login Failed");
                          Fluttertoast.showToast(
                              msg: 'Login Failed',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: grey,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Login()));
                          setState(() {
                            isLoading = false;
                          });
                        }
                      });
                    } else {
                      print("Please fill form correctly");
                    }
                  },
                  animatedTexts: [
                      TyperAnimatedText(
                        'Next →',
                        textStyle: TextStyle(
                          fontFamily: "MontserratSB",
                          fontSize: width * 0.061, //24
                          color: Colors.black,
                        ),
                      )
                    ])
              : Container(),
        )
      ]),
    );
  }
}
