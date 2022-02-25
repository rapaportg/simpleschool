import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simpleschool/model/meeting.dart';

class Event {
  String? classId;
  String? title;
  String? type;
  Meeting meeting;

  Event({required this.classId, required this.meeting, this.title, this.type});

  Meeting getMeeting() {
    return meeting;
  }

  Future<void> addEventToFirebase() async {
    var classEventsColRef = FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection("events");

    var document = {
      'classId': '/classes/' + classId!,
      'className': title,
      'description': "placeholder",
      'eventName': meeting.eventName,
      'from': meeting.from,
      'to': meeting.to,
      'isAllDay': meeting.isAllDay,
      'type': type
    };

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    await classEventsColRef.doc(formatter.format(meeting.from!)).set(document);
  }
}
