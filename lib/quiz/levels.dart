import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mentor_mate/quiz/quiz_page.dart';

import '../globals.dart';

class LevelPage extends StatefulWidget {
  final String? name;
  LevelPage({this.name});

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  bool isLoading = false;
  bool isLoading2 = false;
  List<DocumentSnapshot> chapterCards = [];
  List<DocumentSnapshot> levelCards = [];

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Quizzes')
        .doc(widget.name)
        .collection('Levels')
        .get();
    setState(() {
      levelCards = querySnapshot.docs;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    /*setState(() {
      opacity = 0.0;
      selectedOption = '';
      erroropacity = 0.0;
      chose = false;
      isRight = false;
      seeAnswer = false;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              customBorder: new CircleBorder(),
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                print("This is form data");
                Navigator.pop(context);
              },
              child: Container(
                  height: height! * 0.035, //30
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Center(child: SvgPicture.asset('assets/back.svg')))),
          title: Text(
            widget.name!,
            style: TextStyle(
                fontFamily: 'MontserratB', fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: isLoading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child: CircularProgressIndicator()))
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Quizzes')
                    .doc(widget.name)
                    .collection('Levels')
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                  if (usersnapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: levelCards.length,
                              itemBuilder: (BuildContext context, int index) {
                                String documentId =
                                    usersnapshot.data!.docs[index].id;
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Quizzes')
                                        .doc(widget.name)
                                        .collection('Levels')
                                        .doc(documentId)
                                        .collection('Chapters')
                                        .snapshots(),
                                    builder: (ctx,
                                        AsyncSnapshot<QuerySnapshot>
                                            usersnapshot2) {
                                      if (usersnapshot2.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else {
                                        return ExpansionTile(
                                          /*leading: Container(
                                            height: 37,
                                            width: 37,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.grey
                                                    .withOpacity(0.2)),
                                            /* child: Center(
                                              child: Text(
                                                '${levelCards[index]['level'].toString()}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            ), */
                                          ),*/
                                          title: Text(
                                            levelCards[index]['level'],
                                            style: TextStyle(
                                                fontFamily: 'MontserratSB',
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          children: List.generate(
                                              usersnapshot2.data!.docs.length,
                                              (index1) {
                                            String documentId2 = usersnapshot2
                                                .data!.docs[index1].id;
                                            Map<String, dynamic> chap =
                                                usersnapshot2.data!.docs[index1]
                                                        .data()
                                                    as Map<String, dynamic>;
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            QuizPage(
                                                              sub: widget.name,
                                                              levelid:
                                                                  documentId,
                                                              chapterid:
                                                                  documentId2,
                                                              chaptername: chap[
                                                                  'chapter'],
                                                            )));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 0),
                                                child: Container(
                                                  height: 50,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              width: 0.1))),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        PhosphorIcons.book,
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        child: Text(
                                                          chap['chapter'] !=
                                                                  null
                                                              ? chap['chapter']
                                                              : '',
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      }
                                    });
                              }),
                        ),
                      ],
                    );
                  }
                }));
  }
}
