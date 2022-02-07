import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpleschool/model/class.dart';
import 'package:simpleschool/widget/class_details_widget.dart';
import 'package:simpleschool/widget/create_new_class_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:core';

const double smallFontSize = 12;
const double contWidth = 50;
const double contHeight = 20;

class AddClassWidget extends StatefulWidget {
  final User user;
  final Function() updateParent;
  const AddClassWidget(
      {Key? key, required this.user, required this.updateParent})
      : super(key: key);

  @override
  State<AddClassWidget> createState() => _AddClassWidget(user, updateParent);
}

class _AddClassWidget extends State<AddClassWidget> {
  final User user;
  final Function() updateParent;
  _AddClassWidget(this.user, this.updateParent);

  Widget _searchResults = Text('empty');

  Future<List<Class>> _getAllClasses() async {
    List<Class> list = [];
    var snapshots =
        await FirebaseFirestore.instance.collection('classes').get();

    //print(snapshots.docs.length);
    for (var i = 0; i < snapshots.docs.length; i++) {
      //print(snapshots.docs[i]['name']);
      var tmp = Class(
          snapshots.docs[i].id,
          snapshots.docs[i]['name'],
          snapshots.docs[i]['course_id'],
          snapshots.docs[i]['professor'],
          snapshots.docs[i]['prof_email'],
          snapshots.docs[i]['meeting_schedule'],
          snapshots.docs[i]['meeting_time'],
          snapshots.docs[i]['description'],
          snapshots.docs[i]['university'],
          snapshots.docs[i]['start_date'],
          snapshots.docs[i]['end_date']);

      list.add(tmp);
    }
    // print(list);
    return list;
  }

  //TODO: Figure out how to make this work without exact search
  Future<List<Class>> _getClasses(String search) async {
    List<Class> list = [];
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('classes')
        .where('course_id', isEqualTo: search.trim())
        .get();

    if (snapshots.size > 0) {
      //print(snapshots.docs[0]['name']);
      for (var i = 0; i < snapshots.size; i++) {
        //print(snapshots.docs[i].id);
        var tmp = Class(
            snapshots.docs[i].id,
            snapshots.docs[i]['name'],
            snapshots.docs[i]['course_id'],
            snapshots.docs[i]['professor'],
            snapshots.docs[i]['prof_email'],
            snapshots.docs[i]['meeting_schedule'],
            snapshots.docs[i]['meeting_time'],
            snapshots.docs[i]['description'],
            snapshots.docs[i]['university'],
            snapshots.docs[i]['start_date'],
            snapshots.docs[i]['end_date']);

        list.add(tmp);
      }
    }

    return list;
  }

  Widget _buildSearchResults(String search) {
    List<Widget> list = [];
    //_getAllClasses();
    return FutureBuilder(
      future: search == "" ? _getAllClasses() : _getClasses(search),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return (Center(
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text("Snapshot Error"));
          } else if (snapshot.hasData && snapshot.data!.length > 0) {
            List<Widget> list = [];
            for (var i = 0; i < snapshot.data!.length; i++) {
              list.add(_classItem(snapshot.data![i]));
            }
            return Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(child: list[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  // Convert to listview
                ));
          } else {
            print("empty data");
            return Text("empty data");
          }
        }
        return Text("Testing");
      },
    );
  }

  List<Widget> _meetingSchedulePart(Map<String, dynamic> week) {
    List<Widget> list = [];

    //print(week);

    if (week['monday']) {
      list.add(Text('Mon, '));
    }
    //print('C1');
    if (week['tuesday']) {
      list.add(Text('Tues, '));
    }
    //print('C2');
    if (week['wednesday']) {
      list.add(Text('Wed, '));
    }
    //print('C3');
    if (week['thursday']) {
      list.add(Text('Thur, '));
    }
    //print('C4');
    if (week['friday']) {
      list.add(Text("Fri"));
    }
    return list;
  }

  Widget _meetingSchedule(Map<String, dynamic> meetingSchedule) {
    //print(meetingSchedule);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children: _meetingSchedulePart(meetingSchedule),
      ),
    );
  }

  Widget _classItem1(Class _class) {
    return Container(
        padding: EdgeInsets.all(4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            _class.getName(),
            overflow: TextOverflow.clip,
            maxLines: 2,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SelectableText(
            _class.getCourseId(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
          SelectableText(
            _class.getUni(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ]));
  }

  Widget _classItem2(Class _class) {
    return Container(
        padding: EdgeInsets.all(4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SelectableText(
            _class.getProfName(),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ]));
  }

  Widget _classItem3(Class _class) {
    return Container(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // ignore: prefer_const_constructors
          Text(
            "Session",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "${_class.getStartDateAsStr()} to ${_class.getEndDateAsStr()}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          Text(
            _class.getMeetingTimeAsStr(),
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          _meetingSchedule(_class.getMeetingSchedule()),
        ]));
  }

  Future<void> _updateUsedColors(String _userRef, List<dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userRef)
        .update({'used_colors': data});
  }

  Future<void> _addClass(String _user, String _class, String _className) async {
    var userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(_user).get();

    if (userSnapshot.data()!.containsKey('classes') == false) {
      List<bool> list2 = [
        true,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];
      var data = {'classId': "/classes/$_class", 'color': 0};
      await FirebaseFirestore.instance.collection('users').doc(_user).set({
        "classes": [data],
        "used_colors": list2
      });
      updateParent();
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Added to $_className')));
      return;
    } else {
      List _userClasses = userSnapshot.data()!['classes'];
      print(_userClasses.length);

      if (_userClasses.length >= 8) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('You cannot be in more than 8 classes at a time')));
        return;
      }

      for (int i = 0; i < _userClasses.length; i++) {
        //print(i);
        //print(_userClasses[i]);
        //print("/classes/${_class}");
        if (_userClasses[i]['classId'] == "/classes/$_class") {
          //print("You are already in this class");
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are already in this class')));
          return;
        }
      }
      var index = 0;
      List<dynamic> list = userSnapshot.data()!['used_colors'];
      print(list);
      for (var i = 0; i < list.length; i++) {
        // print("Index $i: ${list[i]}");
        if (list[i] == false) {
          index = i;
          list[i] = true;
          _updateUsedColors(_user, list);
          break;
        }
        index = i;
      }
      list[index] = true;
      _updateUsedColors(_user, list);
      var data = {'classId': "/classes/$_class", 'color': index};
      await FirebaseFirestore.instance.collection('users').doc(_user).update({
        "classes": FieldValue.arrayUnion([data])
      });
      updateParent();
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Added to $_className')));
    }
  }

  Widget _classItem4(Class _class) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(2),
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        //print(_class.getId());
                        return AlertDialog(
                            scrollable: true,
                            content: Padding(
                              padding: const EdgeInsets.all(8),
                              // need to updte to accept class
                              child: ClassDetailsWidget(
                                  classId: '/classes/${_class.getId()}', user: user, updateParent: updateParent,),
                            ));
                      });
                },
                child: Text(
                  "Class Details",
                  style: TextStyle(fontSize: 12),
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(4),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  _addClass(user.uid, _class.getId(), _class.getName());
                },
                child: Text(
                  "Add Class",
                  style: TextStyle(fontSize: 12),
                )),
          ),
        ]));
  }

  Widget _classItem(Class _class) {
    return Container(
        color: Colors.grey.shade200,
        child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(flex: 4, child: _classItem1(_class)),
              //Container(width: MediaQuery.of(context).size.width * 0.01),
              //Spacer(),
              Expanded(flex: 2, child: _classItem2(_class)),
              //Container(width: MediaQuery.of(context).size.width * 0.01),
              //Spacer(),
              Expanded(flex: 4, child: _classItem3(_class)),
              //_meetingSchedule(_class.getMeetingSchedule()),
              //Spacer(),
              Expanded(flex: 2, child: _classItem4(_class)),
              Divider()
            ]));
  }

  Widget _classSearchBar() {
    final _formKey = GlobalKey<FormState>();
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.

            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Enter class name or class code',
                labelText: 'Class Search',
              ),
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) {
                //print(value);
                setState(() {
                  _searchResults = _buildSearchResults(value);
                });
              },
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _searchResults = _buildSearchResults("");
  }

  @override
  Widget build(BuildContext context) {
    //print(user.uid);
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Create new class
                print("add class");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        content: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CreateNewClassWidget(user: user),
                        ),
                      );
                    });
              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.add),
            ),
            body: Column(children: [
              _classSearchBar(),
              Container(
                margin: EdgeInsets.fromLTRB(8, 16, 8, 16),
                width: MediaQuery.of(context).size.width * 0.7,
                // color: Colors.blue.shade100,
                child: _searchResults,
              ),
            ])));
  }
}
