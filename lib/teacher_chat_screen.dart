import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/components/bottom_drawer.dart';
import 'package:mentor_mate/components/popup.dart';
import 'package:mentor_mate/globals.dart';
import 'package:permission_handler/permission_handler.dart';

class TeacherChatScreen extends StatefulWidget {
  final Map<String, dynamic>? userMap;
  //int id;
  String? chatRoomId;

  TeacherChatScreen({
    this.chatRoomId,
    this.userMap,
    /*required this.id*/
  });
  @override
  _TeacherChatScreenState createState() => _TeacherChatScreenState();
}

class _TeacherChatScreenState extends State<TeacherChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    const String _heroAddTodo = 'add-todo-hero';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.082), //70
        child: AppBar(
          leadingWidth: height * 0.082, //70
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
              customBorder: new CircleBorder(),
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: height * 0.035, //30
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Center(child: SvgPicture.asset('assets/back.svg')))),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userMap!['name'],
                style: TextStyle(
                    fontFamily: "MontserratB",
                    fontSize: 16, //24
                    color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                widget.userMap!['studentKey'],
                style: TextStyle(
                    fontFamily: "MontserratM",
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.4)),
              ),
            ],
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(
                    left: width * 0.045, right: width * 0.071), //18 28
                child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(HeroDialogRoute(builder: (context) {
                        return MeetAcceptPopupCard();
                      }));
                    },
                    child: Hero(
                        tag: _heroAddTodo,
                        createRectTween: (begin, end) {
                          return CustomRectTween(begin: begin, end: end);
                        },
                        child: Material(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              height: height * 0.07, //60
                              width: width * 0.152, //60
                              child: Center(
                                  child: SvgPicture.asset('assets/meet.svg'))),
                        ))))
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('chatroom')
                          .doc(widget.chatRoomId)
                          .collection('chats')
                          .doc(widget.chatRoomId)
                          .collection('doubts')
                          .orderBy('servertimestamp', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                              reverse: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;

                                /*if (map['id'] != null) {
                                    setState(() {
                                      id = map['id'];
                                      print(
                                          'inside setState-------------------------------');
                                      print(id);
                                    });
                                  }*/
                                if (map['type'] == 'link') {
                                  return MeetCard();
                                } else {
                                  return map['type'] == 'message'
                                      ? Message(
                                          check: 'teacher',
                                          map: map,
                                        )
                                      : DoubtMessage(map: map);
                                }
                              });
                        } else {
                          print("Tjhis is empty container");
                          return Container();
                        }
                      })),
              Container(
                  height: 80,
                  width: width,
                  color: grey,
                  child: TextInput2(
                    id: widget.userMap!['id'],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class TextInput2 extends StatefulWidget {
  int id;
  TextInput2({required this.id});
  @override
  _TextInput2State createState() => _TextInput2State();
}

class _TextInput2State extends State<TextInput2> {
  File? _image;
  final _picker = ImagePicker();

  void uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);
      var filename = image.path.split('/').last;

      if (image != null) {
        setState(() {
          loader = true;
        });
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('$filename')
            .putFile(file)
            .whenComplete(() {
          setState(() {
            loader = false;
          });
        });

        var downloadUrl = await snapshot.ref.getDownloadURL();

        imageUrl = downloadUrl;
        print(imageUrl);
        onSendMessage();
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final grey = const Color(0xFFe0e3e3).withOpacity(0.5);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.045, vertical: height * 0.021), //18 18
      child: Container(
        height: height * 0.058, //50
        width: width,

        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.014), //12 12
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  uploadImage();
                  //onSendMessage();
                },
                child: Container(
                  height: height * 0.028, //24
                  child: SvgPicture.asset('assets/paperclip.svg'),
                ),
              ),
              SizedBox(
                width: width * 0.025, //10
              ),
              Flexible(
                /*height: 50,
                width: 200,*/
                child: TextFormField(
                  controller: message,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: width * 0.045, //18
                      color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: width * 0.045, //18
                          color: Colors.black.withOpacity(0.3)),
                      hintText: "Type Something ....."),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    type = 'message';
                    id = widget.id;
                  });
                  onSendMessage();
                },
                child: Container(
                  height: height * 0.058, //50
                  width: width * 0.101, //40
                  child: Text(
                    'Send',
                    style: TextStyle(
                        fontFamily: "MontserratM",
                        fontSize: width * 0.035, //14
                        color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
