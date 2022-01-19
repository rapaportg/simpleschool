import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:simpleschool/widget/class_details_widget.dart';

List<Color> colors = [
  Colors.blue.shade300,
  Colors.red.shade300,
  Colors.orange.shade300,
  Colors.green.shade300,
  Colors.purple.shade300,
  Colors.pink.shade300,
  Colors.grey.shade300,
  Colors.yellow.shade300,
  Colors.teal.shade300,
];

Color _getColor(int index) {
  return colors[index];
}

class UserClassListWidget extends StatefulWidget {
  const UserClassListWidget({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  // ignore: no_logic_in_create_state
  _UserClassListWidgetState createState() => _UserClassListWidgetState(user);
}

class _UserClassListWidgetState extends State<UserClassListWidget> {
  final User user;

  _UserClassListWidgetState(this.user);

  Future<List<Widget>> _getClasses() async {
    List<Widget> ret = [];

    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    var numOfClasses = userSnapshot.data()!['classes'].length;
    var _data = userSnapshot.data()!['classes'];

    for (var i = 0; i < numOfClasses; i++) {
      var classRef = await FirebaseFirestore.instance
          .doc("classes/${_data[i]['classId'].id}")
          .get();
      var _className = classRef.data()!['name'];
      var tmp =
          _buildClass(_className, _data[i]['classId'].id, _data[i]['color']);
      print(tmp);
      ret.add(tmp);
    }

    print(ret);
    return ret;
  }

  Widget _buildClass(String _className, String classId, int color) {
    return Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 2, 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.circle,
                      color: _getColor(color),
                      size: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Spacer(flex: 5),
                    Text(
                      _className,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu_outlined, size: 14),
                      onPressed: () {
                        print(classId);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // For class details widget
                              return AlertDialog(
                                content: ClassDetailsWidget(
                                  classId: classId,
                                ),
                              );
                            });
                      },
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    height: 1,
                    color: Colors.grey.shade200),
              ],
            )));
  }

  // List<Widget> _buildClassListWidget() {

  // // }

  @override
  Widget build(BuildContext context) {
    //_getClasses();
    return Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        color: Colors.white,
        child: FutureBuilder(
            future: _getClasses(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text("Error");
                } else if (snapshot.hasData) {
                  print(snapshot.data);
                  return Column(
                    children: snapshot.data!,
                  );
                }
              }
              return Text("State: ${snapshot.connectionState}");
            }));
  }
}
