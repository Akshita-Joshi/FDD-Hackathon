import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_mate/globals.dart';
import 'package:permission_handler/permission_handler.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
Map<String, dynamic>? userMap;

String chatRoomId(String user1, String user2) {
  if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return "$user1$user2";
  } else {
    return "$user2$user1";
  }
}

String roomId = chatRoomId(auth.currentUser!.uid, userMap?['uid']);

void onProvideSolution(String? docId) async {
  var user;
  role == 'student'
      ? await _firestore
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        })
      : await _firestore
          .collection("teachers")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        });

  if (message.text.isNotEmpty || imageUrl != null) {
    final DateTime now = DateTime.now();
    Map<String, dynamic> messages = {
      'id': id,
      "sendby": user['role'].toString(),
      'to': to,
      'type': type,
      'solved': false,
      "message": message.text,
      "time": '${now.hour} : ${now.minute}',
      'name': user['name'].toString(),
      'image_url': imageUrl,
      'servertimestamp': FieldValue.serverTimestamp(),
      'searchKeywords': '{$messageTitle[0]}'
    };
    message.clear();
    await _firestore
        .collection('Forum')
        .doc(docId)
        .collection('solutions')
        .add(messages);
  } else {
    print('Error in text');
  }
}

void getUser() async {
  _firestore.collection("users").doc(auth.currentUser!.uid).get().then((value) {
    print(value.data());
    print(value.data()!['name']);
    currentUser = value.data()!['name'];
  });
}

void onSendMessage() async {
  var user;
  print('--this is role-------$role');
  role == 'student'
      ? await _firestore
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        })
      : await _firestore
          .collection("teachers")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        });

  if (message.text.isNotEmpty || messageTitle.text.isNotEmpty) {
    print(message.text);
    final DateTime now = DateTime.now();
    print('this is user data inside doubts----------------------------------');
    print(user['name']);
    print('this is type--$type');
    if (type != 'forumDoubt') {
      if (message.text.isNotEmpty) {
        if (message.text == "https://meet.google.com/wax-ncmq-eim") {
          print(message.text);
          if (user['role'] == 'student') {
            id = user['messageId'];
          }
          type = 'link';
        } else {
          if (user['role'] == 'student') {
            id = user['messageId'];
          }
          type = 'message';
          print(message.text);
        }
      } else if (messageTitle.text.isNotEmpty) {
        id = Random().nextInt(100000);
        _firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .update({'messageId': id});
        type = 'doubt';
      }
    }
    for (int i = 0; i < messageTitle.toString().length; i++) {}
    Map<String, dynamic> messages = {
      'id': id,
      "sendby": user['role'].toString(),
      'to': to,
      'type': type,
      'description': messageDescription.text,
      'solved': false,
      "message": message.text,
      'title': messageTitle.text,
      "time": '${now.hour} : ${now.minute}',
      'name': user['name'].toString(),
      'studentKey':
          '${user['year']} ${user['branch']} ${user['div']} ${user['roll']}',
      'image_url': imageUrl,
      'servertimestamp': FieldValue.serverTimestamp(),
      'searchKeywords': '{$messageTitle[0]}'
    };
    message.clear();
    messageTitle.clear();
    messageDescription.clear();
    imageUrl = null;
    if (type == 'doubt') {
      addDoubts(messages);
    } else if (type == 'forumDoubt') {
      addForumDoubts(messages);
    }
    await _firestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .doc(roomId)
        .collection('doubts')
        .add(messages);

    type = null;
  } else {
    print('Enter Some Text');
  }
}

void addDoubts(Map<String, dynamic> doubtmessage) async {
  await _firestore.collection('doubts').add(doubtmessage);
}

void addForumDoubts(Map<String, dynamic> doubtmessage) async {
  await _firestore.collection('Forum').add(doubtmessage);
}

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

    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child('folderName/imageName')
          .putFile(file)
          .whenComplete(() {});

      var downloadUrl = await snapshot.ref.getDownloadURL();

      imageUrl = downloadUrl;
      print(imageUrl);

      if (type == 'forumDoubt') {
        onProvideSolution(docId);
      } else {
        onSendMessage();
      }
    } else {
      print('No Path Received');
    }
  } else {
    print('Grant Permissions and try again');
  }
}

void addRequest(String to, String from) async {
  Map<String, dynamic> request = {'to': to, 'from': from};
  print('inside request-------------------------');
  await _firestore.collection('request').add(request);
}
