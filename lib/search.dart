import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mentor_mate/forum.dart';
import 'package:mentor_mate/globals.dart';

class Search extends StatefulWidget {
  String search;
  Map<String, dynamic> teacherMap;

  Search({required this.search, required this.teacherMap});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Forum',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
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
                  child: Center(child: SvgPicture.asset('assets/back.svg')))),
        ),

        //  body:TextField(
        //     controller: _searchController,
        //     decoration: InputDecoration(
        //       prefixIcon: Icon(Icons.search),
        //     ),
        //     onChanged: (val) {
        //       setState(() {
        //         name = val;
        //       });
        //     },
        //   ),
        body: Column(children: [
          StreamBuilder<QuerySnapshot>(
            stream: (name != "" && name != null)
                ? FirebaseFirestore.instance
                    .collection('Forum')
                    // .where("searchKeywords", isEqualTo: widget.search)
                    .snapshots()
                : FirebaseFirestore.instance.collection('Forum').snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          print("THis is title");
                          print(data['title']);
                          print(data['searchKeywords']);
                          print(widget.search);
                          return data['searchKeywords'] == widget.search
                              ? ForumCard(
                                  map: map, teacherMap: widget.teacherMap)
                              //  Card(
                              //     child: Row(
                              //       children: [
                              //         SizedBox(
                              //           width: 20,
                              //         ),
                              //         Text(
                              //           data['title'],
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.w700),
                              //         )
                              //       ],
                              //     ),
                              //   )
                              : Container(
                                  child: Text("Visible?"),
                                  height: 0,
                                );
                        },
                      ),
                    );
            },
          ),
        ]));
  }
}
