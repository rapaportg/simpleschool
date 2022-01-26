import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpleschool/model/class.dart';
import 'package:simpleschool/widget/class_details_widget.dart';
import 'dart:async';
import 'dart:core';

const double smallFontSize = 12;
const double contWidth = 50;
const double contHeight = 20;

class AddClassWidget extends StatefulWidget {
  const AddClassWidget({ Key? key }) : super(key: key);

  @override
  State<AddClassWidget> createState() => _AddClassWidget();
}

class _AddClassWidget extends State<AddClassWidget> {

  Widget _searchResults = Text('empty');

  Future<List<Class>> _getClasses(String search) async {
    List<Class> list = [];

    QuerySnapshot snapshots = await FirebaseFirestore.instance.collection('classes').where('course_id', isEqualTo: search.trim()).get();
    
    if (snapshots.size > 0){
      print(snapshots.docs[0]['name']);
      for (var i=0; i<snapshots.size; i++){
        print(snapshots.docs[i].id);
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
          snapshots.docs[i]['end_date']
          );

        list.add(tmp);
      }
    }
    
    return list;
  }

  Widget _buildSearchResults(String search) {
    List<Widget> list = [];
    return FutureBuilder(
      future: _getClasses(search),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
                return (Center(
                  child: CircularProgressIndicator(),
                ));
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Snapshot Error"));
                } else if (snapshot.hasData && snapshot.data!.length > 0) {
                  List<Widget> list = [];
                  for(var i=0; i<snapshot.data!.length; i++){
                    list.add(_classItem(snapshot.data![i]));
                  }
                  return Column( // Convert to listview
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: list
                      );
                } else {
                  print("empty data");
                  return Text("empty data");
                }
              }
              return Text("Testing");
            },
    );
  }

  List<Widget> _meetingSchedulePart(Map<String,dynamic> week){
    List<Widget> list = [];

    if (week['monday']){
      list.add(Text('Mon, '));
    }
    if (week['tuesday']){
      list.add(Text('Tues, '));
    }
    if (week['wednesday']){
      list.add(Text('Wed, '));
    }
    if (week['thursday']){
      list.add(Text('Thur, '));
    }
    if (week['friday']){
      list.add(Text("Fri"));
    }
    return list;
    
  }

  Widget _meetingSchedule(Map<String, dynamic> meetingSchedule) {
    print(meetingSchedule);
    return Container(
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children:  
          _meetingSchedulePart(meetingSchedule),
        
      ),
    );
  }

  Widget _classItem1(Class _class){
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            _class.getName(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SelectableText(
            _class.getCourseId(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SelectableText(
            _class.getUni(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ]
      )
    );
  }

  Widget _classItem2(Class _class){
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            _class.getProfName(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
          ),
          
        ]
      )
    );
  }

  Widget _classItem3(Class _class){
    return Container(
      padding: EdgeInsets.fromLTRB(16,4,16,4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Session", style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(
            "${_class.getStartDateAsStr()} to ${_class.getEndDateAsStr()}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          _meetingSchedule(_class.getMeetingSchedule()),
        ]
      )
    );
  }

  Widget _classItem4(Class _class){
    return ElevatedButton(
      onPressed: () {
        showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    content: Padding(
                        padding: const EdgeInsets.all(8),
                        // need to updte to accept class
                        child: ClassDetailsWidget(classId: _class.getId()),
                    )
                  );

        });},
      child: Text("View Class Details")
    );
  }

  Widget _classItem(Class _class){
    return Container(
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _classItem1(_class),
          //Container(width: MediaQuery.of(context).size.width * 0.01),
          //Spacer(),
          _classItem2(_class),
          //Container(width: MediaQuery.of(context).size.width * 0.01),
          //Spacer(),
          _classItem3(_class),
          //_meetingSchedule(_class.getMeetingSchedule()),
          //Spacer(),
          _classItem4(_class),
          
        ]
      )
    );
  }

  Widget _classSearchBar() {
    final _formKey = GlobalKey<FormState>();
    return 
      Form(
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
              print(value);
              setState(() {_searchResults = _buildSearchResults(value);});
            },
          )     
        ],
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    width: MediaQuery.of(context).size.width * 0.7,
    height: MediaQuery.of(context).size.height*0.8,
    child: Column(
        children: [
        _classSearchBar(),
        Container(
          margin: EdgeInsets.fromLTRB(8,16,8,16),
          width: MediaQuery.of(context).size.width * 0.7,
         // color: Colors.blue.shade100,
          child: _searchResults,
        ),
       

    ]));
  }
} 