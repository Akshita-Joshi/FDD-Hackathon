import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../globals.dart';

String? selectedOption;
double? opacity = 0.0;
double? erroropacity = 0.0;
bool? chose = false;
bool? isRight = false;
bool? seeAnswer = false;

class QuizPage extends StatefulWidget {
  final String? sub;
  final String? levelid;
  final String? chapterid;
  final String? chaptername;

  QuizPage({this.levelid, this.sub, this.chapterid, this.chaptername});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool isLoading = true;
  List<DocumentSnapshot> questions = [];

  PageController _controller = PageController(
    initialPage: 0,
  );

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Quizzes')
        .doc(widget.sub)
        .collection('Levels')
        .doc(widget.levelid)
        .collection('Chapters')
        .doc(widget.chapterid)
        .collection('quizzes')
        .orderBy('order')
        .get();
    setState(() {
      questions = querySnapshot.docs;
      print('que--$questions');
    });
    setState(() {
      isLoading = false;
    });
    print(questions[0].data());
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      opacity = 0.0;
      selectedOption = '';
      erroropacity = 0.0;
      chose = false;
      isRight = false;
      seeAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
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
          title: Text(
            '${widget.chaptername!}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'MontserratB', fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : questions.length > 0
                ? PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      /*if (_isInterstitialAdReady && showAds) {
                        _interstitialAd?.show();
                      }*/
                      setState(() {
                        opacity = 0.0;
                        erroropacity = 0.0;
                        selectedOption = '';
                        chose = false;
                        isRight = false;
                        seeAnswer = false;
                      });
                    },
                    controller: _controller,
                    itemCount: questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    '${index + 1} / ${questions.length}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              //height: 300,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*questions[index]['title'] != null
                                        ? Text(
                                            '${questions[index]['title']} :',
                                            style: TextStyle(
                                                fontFamily: 'MontserratB',
                                                fontSize: 16),
                                          )
                                        : Container(),*/
                                    SizedBox(
                                      height: 15,
                                    ),
                                    questions[index]['question']['image'] !=
                                            null
                                        ? Container(
                                            height: 160,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Image.network(
                                              questions[index]['question']
                                                  ['image'],
                                              fit: BoxFit.fitHeight,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Container(
                                                  child: Center(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.error_outline,
                                                          size: 12,
                                                          color: Colors.red
                                                              .withOpacity(0.5),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Error loading the image",
                                                          style: TextStyle(
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.5)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ))
                                        : Container(),
                                    questions[index]['question']['caption'] !=
                                            null
                                        ? Text(
                                            questions[index]['question']
                                                    ['caption']
                                                .toString()
                                                .replaceAll('<br>', '\n'),
                                            style: TextStyle(
                                              fontFamily: 'MontserratB',
                                              fontSize: 22,
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    questions[index]['question']['text'] != null
                                        ? Text(
                                            questions[index]['question']
                                                ['text'],
                                            style: TextStyle(
                                              fontFamily: 'MontserratM',
                                              fontSize: 16,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Options(
                              index: index,
                              list: questions,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AnimatedOpacity(
                              opacity: erroropacity!,
                              duration: Duration(milliseconds: 100),
                              child: Text(
                                'Please select an option !',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'MontserratB'),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              height: 50,
                              color: Colors.black,
                              onPressed: () {
                                if (chose == false) {
                                  setState(() {
                                    erroropacity = 1.0;
                                  });
                                } else {
                                  if (opacity == 0.0) {
                                    showRightWrong(
                                      context,
                                      isRight! ? Icons.check : Icons.clear,
                                      isRight! ? Colors.green : Colors.red,
                                      isRight! ? 'Correct' : 'Incorrect',
                                    );
                                    Future.delayed(Duration(milliseconds: 800),
                                        () => Navigator.pop(context));
                                    setState(() {
                                      seeAnswer = true;
                                      opacity = 1.0;
                                    });
                                  } else {
                                    setState(() {
                                      opacity = 0.0;
                                      selectedOption = '';
                                    });
                                    _controller.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                    if (index == questions.length - 1) {
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              },
                              child: Text(
                                opacity != 1.0
                                    ? 'SEE ANSWER'
                                    : index == questions.length - 1
                                        ? 'DONE'
                                        : 'NEXT',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'MontserratB'),
                              ),
                            ),
                            seeAnswer!
                                ? ExpansionTile(
                                    title: Text(
                                      'See Explanation',
                                      style:
                                          TextStyle(fontFamily: 'Montserrat'),
                                    ),
                                    children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0, vertical: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                questions[index]['explanation']
                                                            ['caption'] !=
                                                        null
                                                    ? Text(
                                                        questions[index]
                                                                ['explanation']
                                                            ['caption'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'MontserratB',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                questions[index]['explanation']
                                                            ['text'] !=
                                                        null
                                                    ? Text(
                                                        questions[index][
                                                                    'explanation']
                                                                ['text']
                                                            .toString()
                                                            .replaceAll(
                                                                '<br>', '\n'),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'MontserratM',
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ])
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    })
                : Center(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 20),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'No Quiz to display here, please try after some time'),
                    ],
                  )));
  }
}

class Options extends StatefulWidget {
  final List? list;
  final int? index;
  Options({this.list, this.index});

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool? toggle = false;
  List thisQuestion = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      thisQuestion = widget.list![widget.index!].get('answers');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          itemCount: thisQuestion.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    chose = true;
                    erroropacity = 0.0;
                    selectedOption =
                        widget.list![widget.index!]['answers'][index]['text'];
                    toggle = !toggle!;
                    print(toggle!);
                  });
                  if (widget.list![widget.index!]['answers'][index]
                          ['rightAnswer'] ==
                      true) {
                    setState(() {
                      isRight = true;
                    });
                  } else {
                    setState(() {
                      isRight = false;
                    });
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1)),
                              child: Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                    side: BorderSide.none,
                                    checkColor: Colors.black,
                                    shape: CircleBorder(),
                                    activeColor: Colors.black,
                                    value: (selectedOption ==
                                        widget.list![widget.index!]['answers']
                                            [index]['text']),
                                    onChanged: (value) {
                                      setState(() {
                                        chose = true;
                                        erroropacity = 0.0;
                                        selectedOption =
                                            widget.list![widget.index!]
                                                ['answers'][index]['text'];
                                        toggle = !toggle!;
                                        print(toggle!);
                                        if (widget.list![widget.index!]
                                                    ['answers'][index]
                                                ['rightAnswer'] ==
                                            true) {
                                          isRight = true;
                                        } else {
                                          isRight = false;
                                        }
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                '${widget.list![widget.index!]['answers'][index]['caption']}. ${widget.list![widget.index!]['answers'][index]['text']}',
                                style: TextStyle(
                                    fontFamily: 'MontserratSB', fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        AnimatedOpacity(
                          opacity: opacity!,
                          duration: Duration(milliseconds: 100),
                          child: (widget.list![widget.index!]['answers'][index]
                                      ['rightAnswer'] ==
                                  true)
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : selectedOption ==
                                      widget.list![widget.index!]['answers']
                                          [index]['text']
                                  ? Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    )
                                  : Text(''),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

showRightWrong(BuildContext context, IconData icon, Color color, String text) {
  AlertDialog alert = AlertDialog(
    content: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        height: 90,
        width: 100,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                text,
                style: TextStyle(
                    fontFamily: 'MontserratSB',
                    fontSize: 24,
                    color: Colors.black.withOpacity(0.6)),
              )
            ],
          ),
        ),
      ),
    ),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
