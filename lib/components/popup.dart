import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/doubt_screen.dart';
import 'package:mentor_mate/forum.dart';
import 'package:mentor_mate/globals.dart';

/// {@template hero_dialog_route}
/// Custom [PageRoute] that creates an overlay dialog (popup effect).
///
/// Best used with a [Hero] animation.
/// {@endtemplate}
class HeroDialogRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  HeroDialogRoute({
    @required WidgetBuilder? builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder!,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54.withOpacity(0.3);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

const String _heroAddTodo = 'add-todo-hero';

class MeetRequestPopupCard extends StatefulWidget {
  String from;
  String to;
  MeetRequestPopupCard({required this.from, required this.to});
  @override
  _MeetRequestPopupCardState createState() => _MeetRequestPopupCardState();
}

class _MeetRequestPopupCardState extends State<MeetRequestPopupCard> {
  /// {@macro add_todo_popup_card}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                          height: 70,
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/meet.svg',
                            height: 40,
                          ))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Container(
                          width: 200,
                          child: Text(
                            'Request Teacher for a meet?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontserratM', fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Divider(
                        thickness: 0.2,
                        color: Colors.black,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print(widget.to);
                        print('-------------------------');
                        print(widget.from);
                        print('-------------------------');
                        addRequest(widget.to, widget.from);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Request',
                        style:
                            TextStyle(fontFamily: 'MontserratB', fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template custom_rect_tween}
/// Linear RectTween with a [Curves.easeOut] curve.
///
/// Less dramatic that the regular [RectTween] used in [Hero] animations.
/// {@endtemplate}
class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    @required Rect? begin,
    @required Rect? end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue)!,
      lerpDouble(begin!.top, end!.top, elasticCurveValue)!,
      lerpDouble(begin!.right, end!.right, elasticCurveValue)!,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue)!,
    );
  }
}

const String _heroDoubt = 'doubt';

class DoubtSolvedPopup extends StatefulWidget {
  Map<String, dynamic> map;
  String id;
  String doubtid;
  DoubtSolvedPopup(
      {required this.map, required this.id, required this.doubtid});
  @override
  _DoubtSolvedPopupState createState() => _DoubtSolvedPopupState();
}

class _DoubtSolvedPopupState extends State<DoubtSolvedPopup> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroDoubt,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                        child: DoubtMessage(map: widget.map)),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Container(
                          width: 200,
                          child: Text(
                            'Was your doubt solved?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontserratM', fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Divider(
                        thickness: 0.2,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() async {
                          widget.map['solved'] = true;
                          Map<String, dynamic> message = {
                            'id': widget.map['id'],
                            "sendby": widget.map['sendby'],
                            'to': widget.map['to'],
                            'type': widget.map['type'],
                            'description': widget.map['description'],
                            'solved': true,
                            "message": widget.map['message'],
                            'title': widget.map['title'],
                            "time": widget.map['time'],
                            'name': widget.map['name'],
                            'studentKey': widget.map['studentKey'],
                            'image_url': widget.map['image_url'],
                            'servertimestamp': widget.map['servertimestamp'],
                            'searchKeywords': widget.map['searchKeywords'],
                          };
                          Navigator.pop(context);
                          await FirebaseFirestore.instance
                              .collection('chatroom')
                              .doc(widget.id)
                              .collection('chats')
                              .doc(widget.id)
                              .collection('doubts')
                              .doc(widget.doubtid)
                              .set(message);
                        });
                      },
                      child: const Text(
                        'Yes',
                        style:
                            TextStyle(fontFamily: 'MontserratB', fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForumDoubtPopup extends StatefulWidget {
  Map<String, dynamic> map;
  String id;
  String doubtid;
  ForumDoubtPopup({required this.map, required this.id, required this.doubtid});
  @override
  _ForumDoubtPopupState createState() => _ForumDoubtPopupState();
}

class _ForumDoubtPopupState extends State<ForumDoubtPopup> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroDoubt,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                        child: ForumMessage(map: widget.map)),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Container(
                          width: 200,
                          child: Text(
                            'Was your doubt solved?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontserratM', fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Divider(
                        thickness: 0.2,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() async {
                          widget.map['solved'] = true;
                          Map<String, dynamic> message = {
                            'id': widget.map['id'],
                            "sendby": widget.map['sendby'],
                            'to': widget.map['to'],
                            'type': widget.map['type'],
                            'solved': true,
                            "message": widget.map['message'],
                            "time": widget.map['time'],
                            'name': widget.map['name'],
                            'image_url': widget.map['image_url'],
                            'servertimestamp': widget.map['servertimestamp'],
                            'searchKeywords': widget.map['searchKeywords'],
                          };
                          Navigator.pop(context);
                          await FirebaseFirestore.instance
                              .collection('Forum')
                              .doc(widget.id)
                              .collection('solutions')
                              .doc(widget.doubtid)
                              .set(message);
                        });
                      },
                      child: const Text(
                        'Yes',
                        style:
                            TextStyle(fontFamily: 'MontserratB', fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MeetAcceptPopupCard extends StatefulWidget {
  @override
  _MeetAcceptPopupCardState createState() => _MeetAcceptPopupCardState();
}

class _MeetAcceptPopupCardState extends State<MeetAcceptPopupCard> {
  /// {@macro add_todo_popup_card}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                          height: 70,
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/meet.svg',
                            height: 40,
                          ))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Container(
                          width: 200,
                          child: Text(
                            'Send meet invite?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontserratM', fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Divider(
                        thickness: 0.2,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          type = 'link';
                        });
                        print(message.text);
                        message.text = "https://meet.google.com/wax-ncmq-eim";
                        print(message.text);
                        onSendMessage();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yes',
                        style:
                            TextStyle(fontFamily: 'MontserratB', fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
