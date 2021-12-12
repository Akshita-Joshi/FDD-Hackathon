import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/teacher_chat_screen.dart';

class Doubts extends StatefulWidget {
  Map<String, dynamic> map;
  Map<String, dynamic> teacherMap;
  Doubts({required this.map, required this.teacherMap});
  @override
  _DoubtsState createState() => _DoubtsState();
}

class _DoubtsState extends State<Doubts> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final grey = const Color(0xFFe0e3e3).withOpacity(0.5);
    return Container(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.045, vertical: height * 0.021), //18 18
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.05), //20
              child: Container(
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.map['name'],
                      style: TextStyle(
                          fontFamily: "MontserratM",
                          fontSize: width * 0.035, //14
                          color: Colors.black.withOpacity(0.5)),
                    ),
                    SizedBox(
                      width: width * 0.025, //10
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        width: width,
                        color: grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05,
                  top: 2,
                  bottom: height * 0.011), // 20 2 10
              child: Text(
                widget.map['studentKey'],
                style: TextStyle(
                    fontFamily: "MontserratM",
                    fontSize: width * 0.04, //16
                    color: Colors.black.withOpacity(0.3)),
              ),
            ),
            Row(
              children: [
                Container(
                  height: height * 0.023, //20
                  width: width * 0.05, //20
                  child: Center(
                    child: widget.map['solved']?SvgPicture.asset(
                      'assets/tick.svg',
                      height: 5,
                    ): SvgPicture.asset(
                      'assets/round.svg',
                      height: 5,
                    ),
                  ),
                ),
                Text(widget.map['title'],
                    style: TextStyle(
                      fontFamily: "MontserratSB",
                      fontSize: width * 0.061, //24
                      color: Colors.black,
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05,
                  top: height * 0.011,
                  bottom: height * 0.011), //20 10 10
              child: Text(
                widget.map['description'],
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: width * 0.045, //18
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: height * 0.009), //20 8
              child: Text(widget.map['time'],
                  style: TextStyle(
                      fontFamily: "MontserratM",
                      fontSize: width * 0.035, //14
                      color: Colors.black.withOpacity(0.3))),
            ),
            (widget.map['image_url'] != null)
                ? Image.network(widget.map['image_url']!)
                : Container(
                    height: 0,
                  ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: height * 0.011), //20 10
              child: InkWell(
                onTap: () {
                  String roomId2 =
                      chatRoomId(widget.teacherMap['name'], widget.map['name']);
                  print("this is chatroomid");
                  print(roomId2);
                  setState(() {
                    roomId = roomId2;
                    id = widget.map['id'];
                        print('this is setState id');
                        print(id);
                    to = widget.map['name'];
                    print(roomId2);
                    print(
                        "This is ....................................................................................");
                  });

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TeacherChatScreen(
                            chatRoomId: roomId2,
                            userMap: widget.map,
                            //id:widget.map['id']
                          )));
                },
                child: Container(
                  height: height * 0.047, //40
                  width: width * 0.254, //100
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: grey,
                  ),
                  //border: Border.all(width: 1)),
                  child: Center(
                    child: Text('Reply',
                        style: TextStyle(
                          fontFamily: "MontserratM",
                          fontSize: width * 0.037, //15
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
