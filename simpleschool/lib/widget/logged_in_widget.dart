import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:simpleschool/widget/weekly_calendar_widget_v2.dart';
import 'package:simpleschool/widget/user_class_list_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_validator/string_validator.dart';

class UserLoggedInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    /// Check If Document Exists
    Future<bool> doesUserExist() async {
      var a = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (a.exists) {
        //print('Exists');
        return true;
      }
      if (!a.exists) {
        //print('Not exists');
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'first_login': false});
        return false;
      }
      return false;
    }

    var tmp = doesUserExist();
    if (tmp == true) {
      print(true);
    }

    return Row(children: [
      Expanded(
        flex: 20,
        child: Container(
          color: Colors.lightBlue.shade100,
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 5,
            ),
            CircleAvatar(
              minRadius: 5,
              maxRadius: 42,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            SizedBox(
              height: 8,
            ),
            Text(user.displayName!),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Classes",
                    style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    color: Colors.grey.shade800,
                    padding: EdgeInsets.all(0),
                    hoverColor: Colors.blue,
                    iconSize: 22,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      print("add class");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              content: Padding(
                                padding: const EdgeInsets.all(8),
                                // need to updte to accept class
                                child: Text("test"),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: UserClassListWidget(user: user)),
          ]),
        ),
      ),
      Expanded(flex: 70, child: MyCalendar2(title: "test", user: user)),
      Expanded(
        flex: 20,
        child: Container(
            color: Colors.grey,
            child: Center(
              child: ElevatedButton(
                child: Text("Press me"),
                onPressed: () {
                  // todo
                },
              ),
            )),
      )
    ]);
  }
}
