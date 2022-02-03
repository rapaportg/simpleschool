import 'package:flutter/material.dart';
import 'package:simpleschool/model/meeting.dart';

class Event {
  String docId;
  String? title;
  String? type;
  Meeting meeting;

  Event({required this.docId, required this.meeting, this.title, this.type});

  Meeting getMeeting() {
    return meeting;
  }
}
