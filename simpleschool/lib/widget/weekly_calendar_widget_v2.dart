import 'dart:math';

import 'package:firebase_core_web/firebase_core_web_interop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:simpleschool/model/meeting.dart';
import 'package:simpleschool/widget/calendar_input_form.dart';
import 'package:simpleschool/widget/calendar_input_form_with_to.dart';
import 'package:simpleschool/widget/calendar_input_form_type_menu.dart';
import 'package:simpleschool/widget/event_details_widget.dart';

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

DateFormat dateFormat = DateFormat("yyyy-MM-dd");

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

  DateTime _findMonday(DateTime now) {
    if (now.weekday == DateTime.tuesday) {
      return now.subtract(const Duration(days: 1));
    }
    if (now.weekday == DateTime.wednesday) {
      return now.subtract(const Duration(days: 2));
    }
    if (now.weekday == DateTime.thursday) {
      return now.subtract(const Duration(days: 3));
    }
    if (now.weekday == DateTime.friday) {
      return now.subtract(const Duration(days: 4));
    }
    if (now.weekday == DateTime.saturday) {
      return now.subtract(const Duration(days: 5));
    }
    if (now.weekday == DateTime.sunday) {
      return now.subtract(const Duration(days: 6));
    }
    return now;
  }

  Future<List<Meeting>> _getClasses() async {
    List<Meeting> thisWeeksClasses = [];
    DateTime now = DateTime.now();
    //String nowStr = dateFormat.format(DateTime. now());
    DateTime thisWeekMonday = _findMonday(now);

    print(thisWeekMonday);

    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    var classList = userSnapshot.data()!['classes'];
    print(classList);
    var classEvents;
    var classId;
    var color;

    for (var j = 0; j < classList.length; j++) {
      classId = classList[j]['classId'];
      color = classList[j]['color'];
      //print(classId);
      for (var i = 0; i < 5; i++) {
        
        //print(classId);
        // print(dateFormat.format(thisWeekMonday.add(Duration(days: i))));
        try {
          await FirebaseFirestore.instance
              .doc(classId)
              .collection("events")
              .doc(dateFormat.format(thisWeekMonday.add(Duration(days: i))))
              .get()
              .then((doc) {
            if (doc.exists == true) {
              var data = doc.data()!;
              var meeting = Meeting(
                  data['eventName'],
                  DateTime.fromMillisecondsSinceEpoch(
                      data['from'].seconds * 1000),
                  DateTime.fromMillisecondsSinceEpoch(
                      data['to'].seconds * 1000),
                  colors[color],
                  false,
                  doc.id //firebase id for event
                  );
              thisWeeksClasses.add(meeting);
            }
          });
        } catch (e) {
          //print(e);
          print("Document does not exist");
        }
      }
    }
    //print(classList);
    //print(classList.length);
    print(thisWeeksClasses.length);
    print(thisWeeksClasses);
    return (thisWeeksClasses);
  }

  Future<Widget> _buildAppointmentDetails(String appointmentId) async {
    print('/users/${user.uid}/events/${appointmentId}');
    var appointmentSnapshot = await FirebaseFirestore.instance
        .doc('/users/${user.uid}/events/${appointmentId}')
        .get();

    var eventRef = FirebaseFirestore.instance
        .doc('/events/${appointmentSnapshot.data()!['eventId']}');

    var eventSnapshot = await eventRef.get();
    //return Text(eventSnapshot.data()!['eventName']);
    return EventDetailsWidget(
        user: user, eventRef: eventRef, eventSnapshot: eventSnapshot);

    // ----------------------------------------
    // Make a new widget
    // Todo: [] title
    //       [] time
    //       [] description
    //       [] pdf reader
    //       [] discussion board
    //       [] ability to edit
    // -----------------------------------------
  }

  Widget _calendar(List<Meeting> _meetings) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.week,
      showDatePickerButton: true,
      allowAppointmentResize: true,
      showCurrentTimeIndicator: true,
      timeSlotViewSettings: const TimeSlotViewSettings(timeIntervalHeight: 75),
      monthViewSettings: const MonthViewSettings(showAgenda: true),
      dataSource: MeetingDataSource(_meetings),
      onTap: (CalendarTapDetails details) async {
        print(details.targetElement);

        if (details.targetElement == CalendarElement.appointment) {
          var appointmentIndex = details.targetElement.index;
          String appointmentId = details.appointments![appointmentIndex - 3].id;
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    scrollable: true,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          future: _buildAppointmentDetails(appointmentId),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return (const Center(
                                child: CircularProgressIndicator(),
                              ));
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("Snapshot Error"));
                              } else if (snapshot.hasData) {
                                return snapshot.data;
                              } else {
                                print("empty data");
                                return const Text("empty data");
                              }
                            }
                            return Text(snapshot.data);
                          }),
                    ));
              });
        }
        if (details.targetElement == CalendarElement.calendarCell) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('Select an entry type'),
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
      var meetingId = userEventsSnapshot.docs[i].id;
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
      var _meeting = Meeting(eventName, from, to, color, false, meetingId);
      meetings.add(_meeting);
    }

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    _getClasses();
    _getMeetings();
    return FutureBuilder<List<Meeting>>(
        future: _getClasses(),
        builder: (BuildContext context, AsyncSnapshot<List<Meeting>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (const Center(
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
          return const Text("Testing");
        });
  }
}

Color _getColor(int index) {
  return colors[index];
}
