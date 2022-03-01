import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simpleschool/model/meeting.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Event {
  String? eventId;
  String? classId;
  String? title;
  String? type; // class == lecture (Bad foresight.
  // too much of a hassel to fix right now)
  Meeting meeting;
  String? topic;
  String? chapters; // comma seperated list

  PlatformFile? file;

  Event(
      {required this.classId,
      this.eventId,
      required this.meeting,
      this.title,
      this.type});

  Meeting getMeeting() {
    return meeting;
  }

  void setType(String myType) {
    type = myType;
  }

  void setTopic(String myTopic) {
    topic = myTopic;
  }

  void setChapters(String myChapters) {
    chapters = myChapters;
  }

  void setFile(PlatformFile myfile) {
    file = myfile;
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

  Future<void> updateEventDetailsInFirebase() async {
    print(eventId);
    print(classId);
    print(meeting);
    print(title!);
    print(topic ?? '');
    print(type!);
    print(chapters ?? '');
    print(file!.name);

    TaskSnapshot fileRef;
    var document;
    if (file != null) {
      Uint8List? fileBytes = file!.bytes;

      fileRef = await FirebaseStorage.instance
          .ref('$classId/${file!.name}')
          .putData(fileBytes!);

      document = {
      'classId': classId!,
      'className': title!,
      'topic': topic ?? '',
      'chapters': chapters ?? '',
      'description': "placeholder",
      'eventName': meeting.eventName,
      'from': meeting.from,
      'to': meeting.to,
      'isAllDay': meeting.isAllDay,
      'type': type,
      'file': fileRef.metadata!.fullPath
      };
    }
    else {
      document = {
      'classId': classId!,
      'className': title!,
      'topic': topic ?? '',
      'chapters': chapters ?? '',
      'description': "placeholder",
      'eventName': meeting.eventName,
      'from': meeting.from,
      'to': meeting.to,
      'isAllDay': meeting.isAllDay,
      'type': type,
      };
    }

    var docRef = FirebaseFirestore.instance.doc(eventId!).set(document);
  }
}
