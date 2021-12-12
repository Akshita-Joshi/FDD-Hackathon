import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentor_mate/chat_screen.dart';

class DoubtScreen extends StatefulWidget {
  Map<String, dynamic>? userMap;

  String? chatRoomId;
  DoubtScreen({this.chatRoomId, this.userMap});

  @override
  _DoubtScreenState createState() => _DoubtScreenState();
}

class _DoubtScreenState extends State<DoubtScreen> {
  final TextEditingController _search = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('chatroom')
              .doc(widget.chatRoomId!)
              .collection('chats')
              .doc(widget.chatRoomId!)
              .collection('doubts')
              .orderBy('time', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  print("this is listview");
                  Map<String, dynamic> map =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  print("this is index");
                  print(index);
                  print("this is snapshot");
                  print(snapshot.data!.docs.length);

                  return InkWell(
                    child: messages(size, map),
                    onTap: () {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                    chatRoomId: widget.chatRoomId,
                                    userMap: widget.userMap,
                                  )));*/
                    },
                  );
                },
              );
            } else {
              return Container(
                child: Text("hello this is else"),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget messages(Size size, Map<String, dynamic> map) {
  print("///////////////////////messages.,,,,,,,,,,,,,,,,,,,,");
  return Container(
    width: size.width,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 17),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Center(
        child: Text(
          map['message'],
          style: TextStyle(
            fontFamily: "MontserratM",
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}
