import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/quiz/levels.dart';

class QuizRoute extends StatefulWidget {
  const QuizRoute({Key? key}) : super(key: key);

  @override
  _QuizRouteState createState() => _QuizRouteState();
}

class _QuizRouteState extends State<QuizRoute> {
  bool isLoading = false;
  List<DocumentSnapshot> subCards = [];
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Quizzes').get();
    setState(() {
      subCards = querySnapshot.docs;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Quiz',
            style: TextStyle(
                fontFamily: 'MontserratB', fontSize: 20, color: Colors.black),
          ),
          leading: InkWell(
              customBorder: new CircleBorder(),
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: height! * 0.035, //30
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Center(child: SvgPicture.asset('assets/back.svg')))),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.count(
                  padding: EdgeInsets.all(12),
                  crossAxisCount: 2,
                  children: List.generate(
                      subCards.length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LevelPage(
                                          name: subCards[index]['subject']
                                              .toString())),
                                );
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.05),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /* Container(
                                      height: 70,
                                      width: 70,
                                      child: Image.network(
                                        subCards[index]['icon'],
                                        fit: BoxFit.fitHeight,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Container();
                                        },
                                      ),
                                    ), */
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 100,
                                      child: Text(
                                        subCards[index]['subject'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'MontserratSB',
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          )),
                ),
        ));
  }
}
