import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simpleschool/widget/weekly_calendar_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:simpleschool/model/meeting.dart';
import 'dart:core';

//https://pub.dev/packages/flutter_form_builder
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef void StringCallback(String val);

class CalendarInputFormTypeMenu extends StatelessWidget {
  final StringCallback callback;
  CalendarInputFormTypeMenu({required this.callback});

  String type = '';

  final _formKey1 = GlobalKey<FormBuilderState>();

  bool _validateForm(Map<String, dynamic> form) {
    var data = form['type'];
    if (data == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // CollectionReference events =
    //     FirebaseFirestore.instance.collection('events');
    return Column(
      children: <Widget>[
        FormBuilder(
          key: _formKey1,
          child: Column(
            children: <Widget>[
              FormBuilderChoiceChip(
                name: "type",
                decoration: InputDecoration(
                  labelText: "",
                ),
                onChanged: (value) {
                  if (value == "assignment") {
                    type = "Assignment";
                  } else if (value == "quiz") {
                    type = "Quiz";
                  } else if (value == 'exam') {
                    type = "Exam";
                  } else if (value == 'class') {
                    type = "Class";
                  }

                  //print(type);
                },
                options: [
                  FormBuilderFieldOption(
                      value: 'Assignment', child: Text("Assignment")),
                  FormBuilderFieldOption(value: 'Quiz', child: Text("Quiz")),
                  FormBuilderFieldOption(value: 'Exam', child: Text("Exam")),
                  FormBuilderFieldOption(
                    value: 'Class',
                    child: Text("Class"),
                  ),
                ],
                // Currently Figuring out how to detect which is selected
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
                        if (_validateForm(_formKey1.currentState!.value)) {
                          //print(_formKey1.currentState!.value);
                          callback(_formKey1.currentState!.value['type']);

                          Navigator.pop(context);
                        } else {
                          print("validation failed");
                          //Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                content: Padding(
                                    padding: const EdgeInsets.all(8),
                                    // need to updte to accept class
                                    child: Text("Error: no input"),
                              ),
                          );});
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  // Expanded(
                  //   child: MaterialButton(
                  //     color: Theme.of(context).colorScheme.secondary,
                  //     child: Text(
                  //       "Reset",
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     onPressed: () {
                  //       _formKey1.currentState!.reset();
                  //     },
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
