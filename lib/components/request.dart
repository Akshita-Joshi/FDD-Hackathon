import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/components/popup.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/models/models.dart';

class RequestList extends StatefulWidget {
  Map<String, dynamic> teacherMap;
  RequestList({required this.teacherMap});
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('request').snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 0,
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: usersnapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, index) {
                      Map<String, dynamic> map = usersnapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      print('--------------this is map-------');
                      print(map);
                      return map['to'] == widget.teacherMap['name']
                          ? RequestSentCard(map: map)
                          : Container(height: 0);
                    }),
              );
            }
          }),
    );
  }
}

class RequestSentCard extends StatefulWidget {
  Map<String, dynamic> map;
  RequestSentCard({required this.map});
  @override
  _RequestSentCardState createState() => _RequestSentCardState();
}

class _RequestSentCardState extends State<RequestSentCard> {
  String _heroAddTodo = 'add-todo-hero';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      radius: 320,
      splashColor: Colors.black.withOpacity(0.2),
       onTap: () {       
         
          String roomId1 = chatRoomId(widget.map['from'], widget.map['to']);
       
         
                        setState(() {
                          type = 'link'; 
                          roomId = roomId1;
                        });
                        print(message.text);
                        message.text = "https://meet.google.com/wax-ncmq-eim";
                        print(message.text);
                        onSendMessage();
                      },
      // onTap: () {

      //   });
        
        
      // },
      child:
       Padding(
         padding: EdgeInsets.symmetric(
             horizontal: width * 0.03, vertical: height * 0.0045), //12 4
         child: ClipRRect(
           child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
             child: Container(
               height: height * 0.094, //80
               width: width,
               decoration: BoxDecoration(
                   color: grey.withOpacity(0.4),
                   borderRadius: BorderRadius.circular(10)),
               child: Padding(
                 padding: EdgeInsets.symmetric(horizontal: width * 0.045), //18
                 child: Center(
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Container(
                         height: height * 0.023, //20
                         child: SvgPicture.asset('assets/meet.svg'),
                       ),
                       SizedBox(
                         width: width * 0.05, //20
                       ),
                       Flexible(
                         child: Text(
                           '${widget.map['from']} has requested for a meet',
                           style: TextStyle(
                               fontFamily: "MontserratM",
                               fontSize: width * 0.04 //16
                               ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             ),
           ),
         ),
       ),
    );
  }
}
