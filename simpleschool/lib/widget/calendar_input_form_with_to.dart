import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:simpleschool/model/meeting.dart';
import 'dart:core';

//https://pub.dev/packages/flutter_form_builder
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:string_validator/string_validator.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<Color> colors = [
  Colors.blue.shade100,
  Colors.red.shade100,
  Colors.orange.shade100,
  Colors.green.shade100,
  Colors.purple.shade100,
  Colors.pink.shade100,
  Colors.grey.shade100,
  Colors.yellow.shade100,
  Colors.teal.shade100,
];

class CalendarInputFormWithTo extends StatefulWidget {
  final CalendarTapDetails details;
  final User user;
  String type = '';

  CalendarInputFormWithTo(this.details, this.user, this.type);

  @override
  _CalendarInputFormWithTo createState() =>
      _CalendarInputFormWithTo(details, user, type);
}

class _CalendarInputFormWithTo extends State<CalendarInputFormWithTo> {
  final CalendarTapDetails details;
  User user;
  String type = '';
  _CalendarInputFormWithTo(this.details, this.user, this.type);

  String eventName = '';
  Map<String, String> classId = {'': ''};
  DateTime? date;
  DateTime? from;
  DateTime? to;
  List<String> _classes = [];

  DateTime currentDate = DateTime.now();

  final _formKey1 = GlobalKey<FormBuilderState>();

  String convertIdToIntStr(String id) {
    Map<String, int> codeMap = {
      'a': 1,
      'b': 2,
      'c': 3,
      'd': 52,
      'e': 4,
      'f': 5,
      'g': 6,
      'h': 7,
      'i': 8,
      'j': 9,
      'k': 10,
      'l': 11,
      'm': 12,
      'n': 13,
      'o': 14,
      'p': 15,
      'q': 16,
      'r': 17,
      's': 18,
      't': 19,
      'u': 20,
      'v': 21,
      'w': 22,
      'x': 23,
      'y': 24,
      'z': 25,
      'A': 26,
      'B': 27,
      'C': 28,
      'D': 29,
      'E': 30,
      'F': 31,
      'G': 32,
      'H': 33,
      'I': 34,
      'J': 35,
      'K': 36,
      'L': 37,
      'M': 38,
      'N': 39,
      'O': 40,
      'P': 41,
      'Q': 42,
      'R': 43,
      'S': 44,
      'T': 45,
      'U': 46,
      'V': 47,
      'W': 48,
      'X': 49,
      'Y': 50,
      'Z': 51,
    };

    int? ret = 0;
    for (var i = 0; i < id.length - 1; i++) {
      String char = id.substring(i, i + 1);
      int? number;
      if (isAlpha(char)) {
        number = codeMap[char];
      } else {
        number = int.parse(char);
      }
      ret = ret! * 10 + number!;
    }
    print(ret);
    return ret.toString();
  }

  bool _validateForm(Map<String, dynamic> form) {
    //print("Validator");
    //print(form);
    var eName = form['eventName'].toString().replaceAll(' ', '');

    if (!isAlphanumeric(eName) || eName == '') {
      print("Error eventName not alphanumeric or is empty");
      return false;
    }

    // TODO
    // var classInfo = form['classId'];
    // if ()

    var fromTime = form['from'];
    if (!isDate(fromTime.toString()) || fromTime == null) {
      print("Error: Not a DateTime or null");
    }

    var eventDate = form['date'];
    var year = int.parse(form['date'].toString().split('-')[0]);
    var month = int.parse(form['date'].toString().split('-')[1]);
    var day = int.parse(form['date'].toString().split('-')[2].split(' ')[0]);
    var hour = int.parse(
        form['from'].toString().split('-')[2].split(' ')[1].split(':')[0]);
    var minute = int.parse(
        form['from'].toString().split('-')[2].split(' ')[1].split(':')[1]);

    var hourTo = int.parse(
        form['to'].toString().split('-')[2].split(' ')[1].split(':')[0]);
    var minuteTo = int.parse(
        form['to'].toString().split('-')[2].split(' ')[1].split(':')[1]);

    DateTime finalFrom = DateTime(year, month, day, hour, minute);
    DateTime finalTo = DateTime(year, month, day, hourTo, minuteTo);

    if (!isDate(eventDate.toString()) || eventDate == null) {
      print("Error: Not a date or null");
      return false;
    } else if (!isAfter(finalFrom.toString(), DateTime.now().toString())) {
      print(
          "Error: Entered time has already passed\nEntered DateTime: ${finalFrom.toString()}\nCurrent DateTime: ${DateTime.now().toString()}");
      return false;
    }

    print(finalFrom);
    print(finalTo);
    if (isAfter(finalFrom.toString(), finalTo.toString())) {
      print("Error: To time must be after from time");
      return false;
    }

    return true;
  }

  Future<String> addToCollection(
      String collection, Map<String, dynamic> document) async {
    var col = FirebaseFirestore.instance.collection(collection);
    var docRef = await col.add(document);
    var docId = docRef.id;

    return docId;
  }

  Future<void> saveToDB(Map<String, dynamic> form) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    var year = int.parse(form['date'].toString().split('-')[0]);
    var month = int.parse(form['date'].toString().split('-')[1]);
    var day = int.parse(form['date'].toString().split('-')[2].split(' ')[0]);
    var hour = int.parse(
        form['from'].toString().split('-')[2].split(' ')[1].split(':')[0]);
    var minute = int.parse(
        form['from'].toString().split('-')[2].split(' ')[1].split(':')[1]);
    var hourTo = int.parse(
        form['to'].toString().split('-')[2].split(' ')[1].split(':')[0]);
    var minuteTo = int.parse(
        form['to'].toString().split('-')[2].split(' ')[1].split(':')[1]);

    DateTime finalFrom = DateTime(year, month, day, hour, minute);
    DateTime finalTo = DateTime(year, month, day, hourTo, minuteTo);

    String classId = "VJlD0NUuHGIbu2W5m3bv"; //Placeholder
    String className = "Automata";
    //int color = int.parse(classId, radix: 16);

    var colorRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    int color = 0;
    for (int i = 0; i < colorRef.data()!['classes'].length; i++) {
      if (colorRef.data()!['classes'][i]['classId'] == classId) {
        color = colorRef.data()!['classes'][i]['color'];
      }
    }

    print(color);

    var document = {
      'eventName': form['eventName'],
      'from': finalFrom.toUtc(),
      'isAllDay': false,
      'classId': '/classes/${classId}',
      'className': className,
      'background': color,
      'to': finalTo,
      'type': type,
      'description': "placeholder"
    };

    await addToCollection('events', document);

    await users.doc(user.uid).collection('events').add(document);
  }

  Future<void> _getClasses() async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    print(userSnapshot.data()!);
  }

  @override
  Widget build(BuildContext content) {
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // CollectionReference events =
    //     FirebaseFirestore.instance.collection('events');

    var initialDateTime = details.date;
    _getClasses();
    print(initialDateTime);
    return Column(
      children: <Widget>[
        FormBuilder(
          key: _formKey1,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                enableInteractiveSelection: true,
                name: 'eventName',
                decoration: InputDecoration(
                  labelText: 'Enter Lecture Topic',
                ),
                onChanged: (text) {},
                // valueTransformer: (text) => num.tryParse(text),
              ),

              /// -------------------------------------------------------------------------------------
              /// TODO: Add class selection here
              // FormBuilderDropdown(name: 'Class', items: items)
              /// -------------------------------------------------------------------------------------
              FormBuilderTextField(
                name: 'type',
                decoration: InputDecoration(
                  labelText: "Event Type",
                ),
                initialValue: type,
                enabled: false,
              ),
              FormBuilderDateTimePicker(
                name: 'date',
                // onChanged: _onChanged,
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: 'Enter Date',
                ),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                initialValue: initialDateTime,
                // enabled: true,
              ),
              FormBuilderDateTimePicker(
                name: 'from',
                // onChanged: _onChanged,
                format: DateFormat.jm(),
                inputType: InputType.time,
                decoration: InputDecoration(
                  labelText: 'From Time',
                ),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                initialValue: initialDateTime,
                // enabled: true,
              ),
              FormBuilderDateTimePicker(
                name: 'to',
                // onChanged: _onChanged,
                format: DateFormat.jm(),
                inputType: InputType.time,
                decoration: InputDecoration(
                  labelText: 'To Time',
                ),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                initialValue: initialDateTime!.add(const Duration(hours: 1)),
                // enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey1.currentState!.save();
                        // TODO make validator for formKey1
                        if (_validateForm(_formKey1.currentState!.value)) {
                          saveToDB(_formKey1.currentState!.value);
                          Navigator.pop(context);
                        } else {
                          print("validation failed");
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
