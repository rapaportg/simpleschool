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

List<Color> colors = [
  Colors.blue.shade300,
  Colors.red.shade300,
  Colors.orange.shade300,
  Colors.green.shade300,
  Colors.purple.shade300,
  Colors.pink.shade300,
  Colors.grey.shade300,
  Colors.yellow.shade300,
  Colors.teal.shade300,
];

class MyCalendar2 extends StatefulWidget {
  const MyCalendar2({Key? key, required this.title, required this.user})
      : super(key: key);

  final String title;
  final User user;

  @override
  State<MyCalendar2> createState() => _MyCalendar2(user);
}

//MeetingDataSource? events;

class _MyCalendar2 extends State<MyCalendar2> {
  final User user;
  String entryType = "1";

  List<Color> _colorCollection = <Color>[];

  _MyCalendar2(this.user);

  Widget _calendar(List<Meeting> _meetings) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.week,
      showDatePickerButton: true,
      allowAppointmentResize: true,
      showCurrentTimeIndicator: true,
      monthViewSettings: MonthViewSettings(showAgenda: true),
      dataSource: MeetingDataSource(_meetings),
      onTap: (CalendarTapDetails details) async {
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

  Future<List<Meeting>> _getMeetings() async {
    List<Meeting> meetings = [];
    var userEventsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .get();

    int len = userEventsSnapshot.docs.length;
    for (var i = 0; i < len; i++) {
      var eventName = userEventsSnapshot.docs[i].data()['eventName'];
      //print(userEventsSnapshot.docs[i].data()['classId']);
      //print(userEventsSnapshot.docs[i].data()['className']);
      var color = _getColor(int.parse(
          userEventsSnapshot.docs[i].data()['background'].toString()));

      var from = DateTime.fromMillisecondsSinceEpoch(
          (userEventsSnapshot.docs[i].data()['from'].seconds * 1000));
      var to = DateTime.fromMillisecondsSinceEpoch(
          userEventsSnapshot.docs[i].data()['to'].seconds * 1000);
      //print(userEventsSnapshot.docs[i].data()['type']);
      var _meeting = Meeting(eventName, from, to, color, false);
      meetings.add(_meeting);
    }

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    _getMeetings();
    return FutureBuilder<List<Meeting>>(
        future: _getMeetings(),
        builder: (BuildContext context, AsyncSnapshot<List<Meeting>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (Center(
              child: CircularProgressIndicator(),
            ));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text("Snapshot Error"));
            } else if (snapshot.hasData && snapshot.data!.length > 0) {
              var _meetingData = snapshot.data!.toList();
              return _calendar(_meetingData);
            } else {
              print("empty data");
              return _calendar([]);
            }
          }
          return Text("Testing");
        });
  }
}

Color _getColor(int index) {
  return colors[index];
}
