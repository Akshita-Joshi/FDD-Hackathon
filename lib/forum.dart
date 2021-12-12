import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/components/bottom_drawer.dart';
import 'package:mentor_mate/components/doubt_card.dart';
import 'package:mentor_mate/components/popup.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/search.dart';
import 'package:mentor_mate/teacher_chat_screen.dart';
import 'package:intl/intl.dart';

enum SinginCharacter { lowToHigh, highToLow, alphabetically }

class FormDart extends StatefulWidget {
  Map<String, dynamic> teacherMap;
  FormDart({
    required this.teacherMap,
  });
  @override
  _FormDartState createState() => _FormDartState();
}

class _FormDartState extends State<FormDart> {
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    print(_searchController.text);
  }

  String query = "";
  SinginCharacter _character = SinginCharacter.alphabetically;
  var data;
  @override
  Widget build(BuildContext context) {
    print("This is form data");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Forum',
            style: TextStyle(fontFamily: "MontserratB", color: Colors.black),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        /*leading: InkWell(
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
                child: Center(child: SvgPicture.asset('assets/back.svg')))),*/
      ),
      body: Stack(children: [
        Column(
          children: [
            InkWell(
                child: Container(
                  height: 40,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                        style: TextStyle(
                            fontFamily: "MontserratM",
                            fontSize: 22,
                            color: Colors.black),
                        controller: _searchController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              PhosphorIcons.magnifying_glass,
                            ),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                            enabledBorder: InputBorder.none,
                            hintText: 'Please type what you want ro search',
                            hintStyle: TextStyle(
                                fontFamily: "MontserratM",
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.3)))),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Search(
                                search: _searchController.text,
                                teacherMap: widget.teacherMap,
                              )));
                }),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Forum')
                  .orderBy('servertimestamp', descending: false)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                if (usersnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: usersnapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          data = usersnapshot.data!.docs[index].data();
                          String documentId = usersnapshot.data!.docs[index].id;
                          Map<String, dynamic> map =
                              usersnapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          return map['type'] == 'forumDoubt'
                              ? ForumCard(
                                  docId: documentId,
                                  map: map,
                                  teacherMap: widget.teacherMap,
                                )
                              : Container(
                                  child: Text("hello"),
                                  height: 0,
                                );
                        }),
                  );
                }
              },
            ),
          ],
        ),
        BottomDrawer(
          showMenu: Drawerclass.showMenu,
        )
      ]),
      floatingActionButton: role == 'student'
          ? InkWell(
              onTap: () {
                setState(() {
                  type = 'forumDoubt';
                  Drawerclass.showMenu = true;
                });
              },
              child: Container(
                height: 60,
                width: 100,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(
                          0.0,
                          0.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 4.0,
                      ),
                    ],
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.pencil,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Ask',
                        style: TextStyle(
                            fontFamily: 'MontserratSB',
                            fontSize: 16,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}

class ForumCard extends StatefulWidget {
  Map<String, dynamic> map;
  Map<String, dynamic> teacherMap;
  String? docId;
  ForumCard({required this.map, required this.teacherMap, this.docId});
  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
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
                    child: SvgPicture.asset(
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
                  /*String roomId2 =
                      chatRoomId(widget.map['to'], widget.map['name']);
                  print("this is chatroomid");
                  print(roomId2);
                  setState(() {
                    roomId = roomId2;
                    to = widget.map['name'];
                    print(roomId2);
                  });*/
                  print(widget.docId);
                  setState(() {
                    docId = widget.docId!;
                  });

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ForumChatScreen(
                            chatRoomId: widget.docId!,
                            userMap: widget.map,
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
                    child: Text('Answers',
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

class ForumChatScreen extends StatefulWidget {
  String chatRoomId;
  Map<String, dynamic> userMap;

  ForumChatScreen({required this.chatRoomId, required this.userMap});

  @override
  _ForumChatScreenState createState() => _ForumChatScreenState();
}

class _ForumChatScreenState extends State<ForumChatScreen> {
  String? date = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String month = DateFormat('MMM').format(DateTime(
        0,
        int.parse(widget.userMap['servertimestamp']
            .toDate()
            .toString()
            .substring(5, 7))));
    String year =
        widget.userMap['servertimestamp'].toDate().toString().substring(0, 4);
    String day =
        widget.userMap['servertimestamp'].toDate().toString().substring(8, 10);
    setState(() {
      date = '${day} ${month} ${year}';
    });
  }

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
          /*title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userMap['name'],
                style: TextStyle(
                    fontFamily: "MontserratB",
                    fontSize: 16, //24
                    color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                widget.userMap['studentKey'],
                style: TextStyle(
                    fontFamily: "MontserratM",
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.4)),
              ),
            ],
          ),*/
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  widget.userMap['title'],
                  style: TextStyle(fontFamily: 'MontserratB', fontSize: 26),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  widget.userMap['description'],
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.7)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'by \n${widget.userMap['name']} - ${widget.userMap['studentKey']}\non ${date}',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                width: width,
                color: grey,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Forum')
                          .doc(widget.chatRoomId)
                          .collection('solutions')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return snapshot.data!.docs.length != 0
                              ? ListView.builder(
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

                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return ForumDoubtPopup(
                                              doubtid: document.id,
                                              id: widget.chatRoomId,
                                              map: map);
                                        }));
                                      },
                                      child: Hero(
                                          tag: 'doubt',
                                          createRectTween: (begin, end) {
                                            return CustomRectTween(
                                                begin: begin, end: end);
                                          },
                                          child: ForumMessage(map: map)),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                    'No Answers for now',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black.withOpacity(0.4)),
                                  ),
                                );
                        } else {
                          print("Tjhis is empty container");
                          return Container();
                        }
                      })),
              //Container(width: width, child: TextInput()),
            ],
          ),
          Positioned(
            bottom: 0,
            child: role == 'teacher'
                ? Container(
                    height: 80,
                    width: width,
                    color: grey,
                    child: TextInputForum(docId: widget.chatRoomId),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

class ForumMessage extends StatefulWidget {
  final Map<String, dynamic>? map;
  const ForumMessage({this.map});

  @override
  _ForumMessageState createState() => _ForumMessageState();
}

class _ForumMessageState extends State<ForumMessage> {
  String? date = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String month = DateFormat('MMM').format(DateTime(
        0,
        int.parse(widget.map!['servertimestamp']
            .toDate()
            .toString()
            .substring(5, 7))));
    String year =
        widget.map!['servertimestamp'].toDate().toString().substring(0, 4);
    String day =
        widget.map!['servertimestamp'].toDate().toString().substring(8, 10);
    setState(() {
      date = '${day} ${month} ${year}';
    });
  }

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
                    child: widget.map!['solved']
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
                Text(widget.map!['message'],
                    style: TextStyle(
                      fontFamily: "MontserratSB",
                      fontSize: 18,
                      color: Colors.black,
                    ))
              ],
            ),
            (widget.map!['image_url'] != null)
                ? Image.network(widget.map!['image_url']!)
                : Container(
                    height: 0,
                  ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: height * 0.009), //20 8
              child: Text('by\n${widget.map!['name']} on $date',
                  style: TextStyle(
                      fontFamily: "MontserratM",
                      fontSize: width * 0.035, //14
                      color: Colors.black.withOpacity(0.3))),
            ),
            /*Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: height * 0.009), //20 8
              child: Text(widget.map!['time'].toString(),
                  style: TextStyle(
                      fontFamily: "MontserratM",
                      fontSize: width * 0.035, //14
                      color: Colors.black.withOpacity(0.3))),
            ),*/
          ],
        ),
      ),
    );
  }
}

class TextInputForum extends StatefulWidget {
  final String? docId;
  const TextInputForum({this.docId});
  @override
  _TextInputForumState createState() => _TextInputForumState();
}

class _TextInputForumState extends State<TextInputForum> {
  /*File? _image;
  final _picker = ImagePicker();*/
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
      height: 80, //50
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
                setState(() {
                  type = 'forumDoubt';
                });
                uploadImage();
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
