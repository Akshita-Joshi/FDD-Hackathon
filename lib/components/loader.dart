import 'package:flutter/material.dart';
import 'package:mentor_mate/globals.dart';

class Loader extends StatelessWidget {
  String? message;
  Loader({this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "MontserratSB",
                  fontSize: width! * 0.061, //24
                ),
              ),
              SizedBox(
                height: height! * 0.023, //20
              ),
              Container(
                width: width! * 0.101, //40
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  minHeight: 2,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
