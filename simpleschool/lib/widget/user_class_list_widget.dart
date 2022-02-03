import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simpleschool/widget/add_class_widget.dart';

import 'package:simpleschool/widget/class_details_widget.dart';

List<Color> colors = [
  Colors.blue.shade300,
  Colors.red.shade300,
  Colors.orange.shade300,
  Colors.green.shade300,
  Colors.purple.shade300,
  Colors.pink.shade300,
  Colors.lightGreenAccent.shade400,
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

    if (userSnapshot.data()!.containsKey('classes') == false) {
      return [Text("You arent in any classes")];
    }

    var numOfClasses = userSnapshot.data()!['classes'].length;
    var _data = userSnapshot.data()!['classes'];
    for (var i = 0; i < numOfClasses; i++) {
      var classRef =
          await FirebaseFirestore.instance.doc(_data[i]['classId']).get();
      var _className = classRef.data()!['name'];
      var tmp = _buildClass(_className, _data[i]['classId'], _data[i]['color']);

      ret.add(tmp);
    }

    return ret;
  }

  Widget _buildClass(String _className, String classId, int color) {
    return Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 2, 4),
            child: SingleChildScrollView(
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
                    Spacer(),
                    Expanded(
                      flex: 4,
                      child: Text(
                        _className,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: const Icon(Icons.menu_outlined, size: 14),
                      onPressed: () {
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
            ))));
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
        child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              toolbarHeight: 35,
              elevation: 0,
              centerTitle: false,
              title: const Text(
                'Classes',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
              ),
              actions: [
                IconButton(
                  color: Colors.grey.shade800,
                  padding: EdgeInsets.all(0),
                  hoverColor: Colors.blue,
                  iconSize: 22,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            content: Padding(
                              padding: const EdgeInsets.all(2),
                              // need to updte to accept class
                              child: AddClassWidget(
                                user: user,
                                updateParent: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
            body: FutureBuilder(
                future: _getClasses(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text("Error");
                    } else if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!,
                      );
                    }
                  }
                  return Text("State: ${snapshot.connectionState}");
                })));
  }
}
