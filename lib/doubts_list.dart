import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentor_mate/components/doubt_card.dart';

class DoubtPage extends StatefulWidget {
  String checkYear;
  Map<String, dynamic> teacherMap;
  DoubtPage({required this.checkYear, required this.teacherMap});
  @override
  _DoubtPageState createState() => _DoubtPageState();
}

class _DoubtPageState extends State<DoubtPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doubts').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
          if (usersnapshot.connectionState == ConnectionState.waiting) {
            return Container(child: Center(child: CircularProgressIndicator()));
          } else {
            return ListView.builder(
                itemCount: usersnapshot.data?.docs.length,
                itemBuilder: (BuildContext context, index) {
                  Map<String, dynamic> map = usersnapshot.data!.docs[index]
                      .data() as Map<String, dynamic>;
                  print('--------------this is map-------');
                  print(map);
                  return map['type'] == 'doubt' &&
                          map['studentKey'].toString().substring(0, 2) ==
                              widget.checkYear &&
                          map['to'] == widget.teacherMap['name']
                      ? Doubts(
                          map: map,
                          teacherMap: widget.teacherMap,
                        )
                      : Container(height: 0);
                });
          }
        });
  }
}
