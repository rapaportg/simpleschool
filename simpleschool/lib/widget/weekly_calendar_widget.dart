import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:simpleschool/model/meeting.dart';
import 'package:simpleschool/widget/calendar_input_form.dart';
import 'package:simpleschool/widget/calendar_input_form_with_to.dart';
import 'package:simpleschool/widget/calendar_input_form_type_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key, required this.title, required this.user})
      : super(key: key);

  final String title;
  final User user;

  @override
  State<MyCalendar> createState() => _MyCalendar(user);
}

//MeetingDataSource? events;

class _MyCalendar extends State<MyCalendar> {
  final User user;
  String entryType = "1";
  
  List<Color> _colorCollection = <Color>[];

  _MyCalendar(this.user);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SfCalendar(
      view: CalendarView.week,
      showDatePickerButton: true,
      allowAppointmentResize: true,
      showCurrentTimeIndicator: true,
      monthViewSettings: const MonthViewSettings(showAgenda: true),
      dataSource: MeetingDataSource(_getDataSource()),
      onTap: (CalendarTapDetails details) async {
        // print(details.date!);
        // print(details.appointments);
        // print(details.targetElement);
        //print("${user.displayName}\n${details.date}");
        print(details.targetElement);
      

        if (details.targetElement == CalendarElement.calendarCell) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Select an entry type'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CalendarInputFormTypeMenu(
                        callback: (val) => setState(() => entryType = val)),
                  ),
                );
              });
          //print(entryType);
          if (entryType == 'Assignment') {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    content: Padding(
                        padding: const EdgeInsets.all(8),
                        // need to updte to accept class
                        child: CalendarInputForm(details, user, entryType)),
                  );
                });
          } else if (entryType == 'Class' ||
              entryType == 'Exam' ||
              entryType == 'Quiz') {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    content: Padding(
                        padding: const EdgeInsets.all(8),
                        // need to updte to accept class
                        child:
                            CalendarInputFormWithTo(details, user, entryType)),
                  );
                });
          }
        }
        
      },
    ));
  }
}

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];

  final DateTime today = DateTime.now();
  DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
  DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      'Conference', startTime, endTime, const Color(0xFF0F8644), false));

  startTime = DateTime(today.year, today.month, today.day - 1, 12, 0, 0);
  endTime = startTime.add(const Duration(hours: 1));
  meetings
      .add(Meeting('Doctors', startTime, endTime, randomOpaqueColor(), false));

  startTime = DateTime(today.year, today.month, today.day + 2, 14, 0, 0);
  endTime = startTime.add(const Duration(hours: 1));
  meetings
      .add(Meeting('Doctors', startTime, endTime, randomOpaqueColor(), false));

  startTime = DateTime(today.year, today.month, today.day + 4, 15, 0, 0);
  endTime = startTime.add(const Duration(hours: 1));
  meetings
      .add(Meeting('Doctors', startTime, endTime, randomOpaqueColor(), false));

  return meetings;
}
