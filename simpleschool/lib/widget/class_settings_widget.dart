import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClassSettingsWidget extends StatefulWidget {
  User user;
  dynamic data;
  Function updateParent;

  ClassSettingsWidget(
      {Key? key,
      required this.user,
      required this.data,
      required this.updateParent})
      : super(key: key);

  @override
  _ClassSettingsWidgetState createState() =>
      _ClassSettingsWidgetState(user, data, updateParent);
}

class _ClassSettingsWidgetState extends State<ClassSettingsWidget> {
  User user;
  dynamic data;
  Function updateParent;

  _ClassSettingsWidgetState(this.user, this.data, this.updateParent);

  Future<void> _removeClassFromUserList(String classId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    List usedColors = snapshot.data()!['used_colors'];
    List classList = snapshot.data()!['classes'];
    String tmp = "/classes/$classId";
    for (int i = 0; i < classList.length; i++) {
      if (classList[i]['classId'] == tmp) {
        print("true: $i");
        var color = classList[i]['color'];
        usedColors[color] = false;
        classList.removeAt(i);
      }
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'classes': classList, 'used_colors': usedColors});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          child: Text("Drop Class"),
          onPressed: () async {
            await _removeClassFromUserList(data['id']);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            updateParent();
          },
        ));
  }
}
