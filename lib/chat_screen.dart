import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/components/bottom_drawer.dart';
import 'package:mentor_mate/components/popup.dart';
import 'package:mentor_mate/models/models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart';

//this file has the chat screen
var loader;

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? userMap;
  String? chatRoomId;
  String name1;
  String name2;

  ChatScreen(
      {this.chatRoomId,
      this.userMap,
      required this.name1,
      required this.name2});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    const String _heroAddTodo = 'add-todo-hero';
    const String _heroDoubt = 'doubt';

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
          title: Text(
            widget.userMap!['name'],
            maxLines: 2,
            style: TextStyle(
                fontFamily: "MontserratB",
                fontSize: 18, //24
                color: Colors.black),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.045, right: width * 0.071), //18 28
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = 'doubt';
                        Drawerclass.showMenu = true;
                      });
                    },
                    child: Text("AskDoubt",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: width * 0.04, //16
                            color: Colors.black)),
                  ),
                  SizedBox(
                    width: width * 0.076, //30
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(HeroDialogRoute(builder: (context) {
                          return MeetRequestPopupCard(
                              to: widget.name2, from: widget.name1);
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
                                    child:
                                        SvgPicture.asset('assets/meet.svg'))),
                          )))

                  /*Container(
                        height: width * 0.152, //60
                        child:
                            Center(child: SvgPicture.asset('assets/meet.svg'))),*/
                ],
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 1,
                width: width,
                color: grey,
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('chatroom')
                          .doc(widget.chatRoomId)
                          .collection('chats')
                          .doc(widget.chatRoomId)
                          .collection('doubts')
                          .orderBy('servertimestamp', descending: true)
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
                                if (map['type'] == 'link') {
                                  return MeetCard();
                                } else {
                                  return map['type'] == 'message'
                                      ? Message(
                                          check: 'student',
                                          map: map,
                                        )
                                      : InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                              return DoubtSolvedPopup(
                                                  doubtid: document.id,
                                                  id: widget.chatRoomId!,
                                                  map: map);
                                            }));
                                          },
                                          child: Hero(
                                              tag: 'doubt',
                                              createRectTween: (begin, end) {
                                                return CustomRectTween(
                                                    begin: begin, end: end);
                                              },
                                              child: DoubtMessage(map: map)));
                                }
                              });
                        } else {
                          return Container();
                        }
                      })),
              Container(
                  height: 80, color: grey, width: width, child: TextInput()),
            ],
          ),

          //this widget is bottom drawer
          BottomDrawer(
            showMenu: Drawerclass.showMenu,
          )
        ],
      ),
    );
  }
}

class Message extends StatefulWidget {
  Map<String, dynamic> map;
  String check;
  Message({required this.map, required this.check});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final grey = const Color(0xFFe0e3e3).withOpacity(0.5);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.061, vertical: height * 0.009), //24 8
      child: Container(
        alignment: widget.map['sendby'] == widget.check
            ? Alignment.topRight
            : Alignment.topLeft,
        child: (widget.map['image_url'] != null)
            ? Container(
                decoration: BoxDecoration(
                    color: grey, borderRadius: BorderRadius.circular(10)),
                width: 200,
                height: 200,
                child: Center(
                    child: loader == true
                        ? CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                                color: grey,
                                borderRadius: BorderRadius.circular(10)),
                            width: 180,
                            height: 180,
                            child: Image.network(
                              widget.map['image_url'],
                              fit: BoxFit.cover,
                            ),
                          )))
            : Container(
                constraints: BoxConstraints(
                    maxWidth: width * 0.71, minWidth: width * 0.25), //280 100
                decoration: BoxDecoration(
                    color: grey, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: height * 0.018), //16 16
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(/*widget.message!*/ widget.map['message'],
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: width * 0.045, //18
                              color: Colors.black)),
                      SizedBox(height: height * 0.009), //8
                      Text(widget.map['time'].toString(),
                          style: TextStyle(
                              fontFamily: "MontserratM",
                              fontSize: width * 0.025, //10
                              color: Colors.black.withOpacity(0.3)))
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class DoubtMessage extends StatefulWidget {
  Map<String, dynamic> map;
  DoubtMessage({required this.map});
  @override
  _DoubtMessageState createState() => _DoubtMessageState();
}

class _DoubtMessageState extends State<DoubtMessage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.045, vertical: height * 0.021), //18 18
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: height * 0.023, //20
                  width: width * 0.05, //20
                  child: Center(
                    child: widget.map['solved']
                        ? SvgPicture.asset(
                            'assets/tick.svg',
                            height: 10,
                          )
                        : SvgPicture.asset(
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
            (widget.map['image_url'] != null)
                ? Image.network(widget.map['image_url']!)
                : Container(
                    height: 0,
                  ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: height * 0.009), //20 8
              child: Text(widget.map['time'].toString(),
                  style: TextStyle(
                      fontFamily: "MontserratM",
                      fontSize: width * 0.035, //14
                      color: Colors.black.withOpacity(0.3))),
            ),
          ],
        ),
      ),
    );
  }
}

class TextInput extends StatefulWidget {
  final String? docId;
  const TextInput({this.docId});
  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  File? _image;
  final _picker = ImagePicker();
  /*void uploadImage() async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final grey = const Color(0xFFe0e3e3).withOpacity(0.5);
    return Container(
      height: height * 0.058, //50
      width: width,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.014), //12 12
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                });
                if (widget.docId != null) {
                  onProvideSolution(widget.docId);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  alignment: Alignment.center,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MeetCard extends StatefulWidget {
  const MeetCard({Key? key}) : super(key: key);

  @override
  _MeetCardState createState() => _MeetCardState();
}

class _MeetCardState extends State<MeetCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        const url = "https://meet.google.com/wax-ncmq-eim";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.061, vertical: height * 0.009), //24 8
        child: Container(
          child: Container(
            //280 100
            decoration: BoxDecoration(
                color: grey, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.018), //16 16
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('This is your meeting link',
                      style: TextStyle(
                          fontFamily: "MontserratM",
                          fontSize: 16, //18
                          color: Colors.black)),
                  SizedBox(height: 8), //8
                  Text(meetlink!,
                      style: TextStyle(
                          fontFamily: "MontserratM",
                          fontSize: 18, //10
                          color: Colors.black))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
