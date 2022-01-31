import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:core';
import 'package:intl/intl.dart';

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
  CreateNewClassWidget({Key? key}) : super(key: key);

  @override
  State<CreateNewClassWidget> createState() => _CreateNewClassWidgetState();
}

class _CreateNewClassWidgetState extends State<CreateNewClassWidget> {
  final _formKey = GlobalKey<FormBuilderState>();



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Scaffold(
          //extendBody: true,
          //bottomSheet: Text("af"),
          resizeToAvoidBottomInset: true,
          floatingActionButton: FloatingActionButton(
            child: Text("Save"),
            onPressed: () {
              _formKey.currentState!.save();
              print(_formKey.currentContext);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('I dont work yet!')));
        
            },
          ),
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
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      enableInteractiveSelection: true,
                      name: 'className',
                      decoration: InputDecoration(
                        labelText: 'Class Name',
                      ),
                      onSaved: (data) {

                      },
                    ),
                    FormBuilderTextField(
                      enableInteractiveSelection: true,
                      name: 'courseId',
                      decoration: InputDecoration(
                        labelText: 'Course ID',
                      ),
                    ),
                    FormBuilderTextField(
                      enableInteractiveSelection: true,
                      name: 'location',
                      decoration: InputDecoration(
                        labelText: 'Location',
                      ),
                    ),
                    FormBuilderTextField(
                      enableInteractiveSelection: true,
                      name: "professor",
                      decoration: InputDecoration(
                        labelText: "Professor's name",
                      ),
                    ),
                    FormBuilderTextField(
                      enableInteractiveSelection: true,
                      name: "profEmail",
                      decoration: InputDecoration(
                        labelText: "Professor's email",
                      ),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      // onChanged: _onChanged,
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: 'Enter Date',
                      ),
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                      initialValue: DateTime.now(),
                      // enabled: true,
                    ),
                    FormBuilderDateTimePicker(
                      name: 'from',
                      // onChanged: _onChanged,
                      format: DateFormat.jm(),
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'From:',
                      ),
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                      initialValue: DateTime.now(),
                      // enabled: true,
                    ),
                    FormBuilderDateTimePicker(
                      name: 'to',
                      // onChanged: _onChanged,
                      format: DateFormat.jm(),
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'To:',
                      ),
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                      initialValue:
                          DateTime.now().add(const Duration(hours: 1)),
                      // enabled: true,
                    ),
                  ],
                ),
              ))),
    );
  }
}
