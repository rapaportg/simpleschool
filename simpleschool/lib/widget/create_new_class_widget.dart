import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:yaml/yaml.dart';
import 'package:simpleschool/model/class.dart';
import 'package:simpleschool/model/event.dart';

// course_id
// description
// end_date
// start_date
// meeting_schedule
// meeting_time
// name
// professor
// prof_email
// ta
// location
// ta_email
// university
// TODO: Assignments class
// TODO: pdf reader for syllabus
// TODO discussion board

class CreateNewClassWidget extends StatefulWidget {
  User user;
  CreateNewClassWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<CreateNewClassWidget> createState() => _CreateNewClassWidgetState(user);
}

class _CreateNewClassWidgetState extends State<CreateNewClassWidget> {
  User user;
  _CreateNewClassWidgetState(this.user);

  final _formKey = GlobalKey<FormBuilderState>();

  String? className;
  String? courseId;
  String? location;
  String? professor;
  String? profEmail;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? from;
  DateTime? to;
  Map<String, Map<String, num>>? meetingTime;

  Map<String, Map<String, num>> _generateMeetingTimeForFirebase(
      DateTime? from, DateTime? to) {
    Map<String, Map<String, num>> _meetingTime = {
      'start': {'hour': from!.hour, 'minute': from.minute},
      'end': {'hour': to!.hour, 'minute': to.minute}
    };

    //print(_meetingTime);

    return _meetingTime;
  }

  Map<String, bool> _generateMeetingScheduleForFirestore(List<String> data) {
    Map<String, bool> _meetingSchedule = {
      'monday': false,
      'tuesday': false,
      'wednesday': false,
      'thursday': false,
      'friday': false,
    };

    for (var i = 0; i < data.length; i++) {
      _meetingSchedule[data[i]] = true;
    }
    //print(_meetingSchedule);

    return _meetingSchedule;
  }

  Future<void> _addNewClassToUser(
      DocumentReference _classRef, String _className) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

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
      var data = {'classId': "/classes/${_classRef.id}", 'color': 0};
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        "classes": [data],
        "used_colors": list2
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Added to $_className')));
      Navigator.pop(context);
      return;
    } else {
      List<dynamic> usedColors = userSnapshot.data()!['used_colors'];
      for (var i = 0; i < usedColors.length; i++) {
        if (usedColors[i] == false) {
          usedColors[i] = true;
          var data = {'classId': "/classes/${_classRef.id}", 'color': 0};
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            "classes": FieldValue.arrayUnion([data]),
            "used_colors": usedColors
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Added to $_className')));
          Navigator.pop(context);
          return;
        }
      }
    }
  }

  Future<List<Event>> _initEvents(String docId, Map document) async {
    List<Event> events = [];

    DateTime? startDate = document['start_date'];
    DateTime? endDate = document['end_date'];
    var numOfEvents = startDate!.difference(endDate!).inDays;
    print(numOfEvents);

    return events;
  }

//TODO: add check to see if class already exists
  Future<void> _addClassToFirestore(Map<String, dynamic> data) async {
    // add check to see if this class already exists
    var document = {
      'name': data['className'],
      'course_id': data['courseId'],
      'university': data['school'],
      'location': data['location'],
      'professor': data['professor'],
      'prof_email': data['profEmail'],
      'start_date': data['startDate'],
      'end_date': data['endDate'],
      'meeting_schedule':
          _generateMeetingScheduleForFirestore(data['meetingSchedule']),
      'meeting_time': _generateMeetingTimeForFirebase(data['from'], data['to']),
      'description': 'Add course description here',
      'ta' : '',
      'ta_email': ''
    };

    var docID =
        await FirebaseFirestore.instance.collection('classes').add(document);
    //print(docID);
    var events = await _initEvents(docID.id, document);

    await _addNewClassToUser(docID, data['className']);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Scaffold(
          //extendBody: true,
          //bottomSheet: Text("af"),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text("Create a new class",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue.shade400,
          ),
          body: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              color: Colors.white,
              child: FormBuilder(
                  autoFocusOnValidationFailure: true,
                  key: _formKey,
                  child: SingleChildScrollView(
                    //controller: controller,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.words,
                          enableInteractiveSelection: true,
                          name: 'className',
                          decoration: const InputDecoration(
                            labelText: 'Enter class name',
                          ),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: true,
                          textCapitalization: TextCapitalization.characters,
                          name: 'courseId',
                          decoration: InputDecoration(
                            labelText: 'Enter course id',
                          ),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: true,
                          name: "school",
                          decoration: InputDecoration(
                            labelText: "Enter university",
                          ),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          textCapitalization: TextCapitalization.words,
                          enableInteractiveSelection: true,
                          name: 'location',
                          decoration: InputDecoration(
                            labelText: 'Enter location',
                          ),
                        ),
                        FormBuilderTextField(
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: true,
                          name: "professor",
                          decoration: InputDecoration(
                            labelText: "Enter professor's name",
                          ),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: true,
                          textCapitalization: TextCapitalization.none,
                          name: "profEmail",
                          decoration: InputDecoration(
                            labelText: "Enter professor's email",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.email(context),
                          ]),
                        ),
                        FormBuilderDateTimePicker(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          name: 'startDate',
                          inputType: InputType.date,
                          decoration: InputDecoration(
                            labelText: 'Enter Start Date',
                          ),
                          initialTime: TimeOfDay(hour: 8, minute: 0),
                          initialValue: null,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            (val) {
                              if (val == null) return "Invalid input";
                            },
                          ]),
                          onChanged: (data) {
                            setState(() {
                              startDate = data;
                            });
                          },
                          enabled: true,
                        ),
                        FormBuilderDateTimePicker(
                          name: 'endDate',
                          inputType: InputType.date,
                          decoration: InputDecoration(
                            labelText: 'Enter end date',
                          ),
                          initialTime: TimeOfDay(hour: 8, minute: 0),
                          initialValue: null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            (val) {
                              // if (val == null) {
                              //   return "Invalid input";
                              // }
                              final end = val;
                              final start = startDate;
                              if (start!.isAfter(end!)) {
                                return "End date cannot be before start date";
                              } else {
                                return null;
                              }
                            }
                          ]),
                          onChanged: (data) {
                            setState(() {
                              endDate = data;
                            });
                          },
                        ),
                        FormBuilderDateTimePicker(
                          name: 'from',
                          format: DateFormat.jm(),
                          inputType: InputType.time,
                          decoration: InputDecoration(
                            labelText: 'Enter class start time',
                          ),
                          initialTime: TimeOfDay(hour: 8, minute: 0),
                          initialValue: null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          onChanged: (data) {
                            print(data);
                            setState(() {
                              from = data;
                            });
                          },
                        ),
                        FormBuilderDateTimePicker(
                          name: 'to',
                          format: DateFormat.jm(),
                          inputType: InputType.time,
                          decoration: InputDecoration(
                            labelText: 'Enter class end time',
                          ),
                          initialTime: TimeOfDay(hour: 8, minute: 0),
                          initialValue: null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            (val) {
                              return (from!.isAfter(val!))
                                  ? "To must come after from"
                                  : null;
                            }
                          ]),
                        ),
                        FormBuilderCheckboxGroup(
                          decoration:
                              InputDecoration(labelText: "Meeting Schedule"),
                          wrapDirection: Axis.vertical,
                          name: 'meetingSchedule',
                          options: [
                            FormBuilderFieldOption(
                                value: 'monday', child: Text("Mon")),
                            FormBuilderFieldOption(
                                value: 'tuesday', child: Text("Tues")),
                            FormBuilderFieldOption(
                                value: 'wednseday', child: Text("Wed")),
                            FormBuilderFieldOption(
                              value: 'thursday',
                              child: Text("Thur"),
                            ),
                            FormBuilderFieldOption(
                              value: 'friday',
                              child: Text("Fri"),
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Spacer(),
                              ElevatedButton(
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              ElevatedButton(
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onPressed: () {
                                  _formKey.currentState!.save();
                                  if (_formKey.currentState!.validate()) {
                                    //print(_formKey.currentState!.value);
                                    _addClassToFirestore(
                                        _formKey.currentState!.value);
                                  } else {
                                    print("validation failed");
                                  }

                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  // reload user_class_list and calendar
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(
                                  //         duration: Duration(seconds: 4),
                                  //         content: Text('I dont work yet!')));
                                },
                              ),
                              Spacer(),
                            ]),
                      ],
                    ),
                  )))),
    );
  }
}
