import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentor_mate/authentication/authenticate.dart';
import 'package:mentor_mate/authentication/login.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/home.dart';

class TeacherLogin extends StatefulWidget {
  @override
  _TeacherLoginState createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  double nameOpacity = 0.0;
  double fyOpacity = 0.0;
  double syOpacity = 0.0;
  double tyOpacity = 0.0;
  double btechOpacity = 0.0;
  double seqOpacity = 0.0;
  double present = 0.0;

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
                        "Register ",
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
                      //--------------------------------
                      _label(seqOpacity, "Sequence No."),
                      TextFormField(
                        controller: seqControllerT,
                        style: _inputText(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: _hintText(),
                            hintText: "Enter 8 digit Sequence no."),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? seqOpacity = 1 : seqOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          var myList = [
                            '83895123',
                            '39128123',
                            '63385123',
                            '05250123',
                            '49709123'
                          ];
                          for (var i = 0; i < myList.length; i++) {
                            if (value == myList[i]) {
                              setState(() {
                                present = 1.0;
                              });
                              break;
                            }
                          }
                          print(seqControllerT.text);
                          if (present == 1.0) {
                            print('$value is present in the list $myList');
                          } else {
                            print('$value is not present in the list $myList');
                          }
                        },
                      ),
                      SizedBox(height: height * 0.011), //10
                      _label(nameOpacity, "Name"),
                      TextFormField(
                        controller: nameControllerT,
                        style: _inputText(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: _hintText(),
                            hintText: "Enter Name"),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? nameOpacity = 1 : nameOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          _callOnTop();
                        },
                      ),
                      SizedBox(height: height * 0.011), //10
                      _label(fyOpacity, "FY Subject"),
                      TextFormField(
                        controller: fyControllerT,
                        style: _inputText(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: _hintText(),
                            hintText: "Enter FY Subject"),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? fyOpacity = 1 : fyOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          _callOnTop();
                        },
                      ),
                      SizedBox(height: height * 0.011),
                      _label(syOpacity, "SY Subject"),
                      TextFormField(
                        controller: syControllerT,
                        style: _inputText(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: _hintText(),
                            hintText: "Enter SY Subject"),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? syOpacity = 1 : syOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          _callOnTop();
                        },
                      ),
                      SizedBox(height: height * 0.011),
                      _label(tyOpacity, "TY Subject"),
                      TextFormField(
                        controller: tyControllerT,
                        style: _inputText(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: _hintText(),
                            hintText: "Enter TY Subject"),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? tyOpacity = 1 : tyOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          _callOnTop();
                        },
                      ),
                      SizedBox(height: height * 0.011),
                      _label(btechOpacity, "BTech Subject"),
                      TextFormField(
                        controller: btechControllerT,
                        style: _inputText(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: _hintText(),
                            hintText: "Enter BTech Subject"),
                        onChanged: (value) {
                          setState(() {
                            value != '' ? btechOpacity = 1 : btechOpacity = 0;
                          });
                        },
                        onFieldSubmitted: (value) {
                          _callOnTop();
                        },
                      ),
                      SizedBox(height: height * 0.011),
                      //--------------------------------

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
          bottom: height * 0.070, //60
          child: [nameOpacity, present].every((element) => element == 1.0)
              ? AnimatedTextKit(
                  pause: Duration(milliseconds: 1500),
                  repeatForever: true,
                  onTap: () {
                    addTeacher();
                    Fluttertoast.showToast(
                        msg: 'Registered Successfully',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: grey,
                        textColor: Colors.black,
                        fontSize: 16.0);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  },
                  animatedTexts: [
                      TyperAnimatedText(
                        'Next →',
                        textStyle: TextStyle(
                          fontFamily: "MontserratSB",
                          fontSize: width * 0.0611, //24
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
