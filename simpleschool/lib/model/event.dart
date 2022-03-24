// ignore_for_file: non_constant_identifier_names

import 'dart:async';
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
  String? chapters;
  String? description; // comma seperated list

  List fileStoragePath;
  Uint8List? rawFile;
  PlatformFile? file;
  String? downloadUrl;
  String? chatId;

  bool hasFiles;

  Event(
      {required this.classId,
      this.eventId,
      required this.meeting,
      this.title,
      this.type,
      this.downloadUrl,
      this.topic,
      this.chapters,
      this.description,
      this.chatId,
      required this.hasFiles,
      required this.fileStoragePath});

  Meeting getMeeting() {
    return meeting;
  }

  void setType(String myType) {
    type = myType;
  }

  String getType() {
    return type!;
  }

  void setDownloadUrl({int i = 0}) async {
    var ref = FirebaseStorage.instance.ref(fileStoragePath[i]);
    downloadUrl = await ref.getDownloadURL();
  }

  Uint8List getRawFile() {
    return rawFile!;
  }

  // accepts int index value if for later development of more than 1 pdf at a time
  Future<String> getFileURL(int i) async {
    var ref = FirebaseStorage.instance.ref(fileStoragePath[i]);
    String tmp = await ref.getDownloadURL();
    return tmp;
  }

  void setTopic(String myTopic) {
    topic = myTopic;
  }

  void setDescription(String myDesc) {
    description = myDesc;
  }

  String getTopic() {
    return topic ?? "";
  }

  String getChapters() {
    return chapters ?? "";
  }

  String getDescription() {
    return description ?? "";
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
      'type': type,
      'fileStoragePath': [],
      'hasFiles': false
    };

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    await classEventsColRef.doc(formatter.format(meeting.from!)).set(document);
  }

  Future<void> updateEventDetailsInFirebase() async {
    TaskSnapshot snapshot;
    String downloadUrl = '';
    Map<String, dynamic> document;
    if (file != null) {
      document = {
        'classId': classId!,
        'className': title!,
        'topic': topic ?? '',
        'chapters': chapters ?? '',
        'description': description ?? '',
        'eventName': meeting.eventName,
        'from': meeting.from,
        'to': meeting.to,
        'isAllDay': meeting.isAllDay,
        'type': type,
        'fileStoragePath': [],
        'hasFiles': false,
      };
      Uint8List? fileBytes = file!.bytes;

      snapshot = await FirebaseStorage.instance
          .ref('$eventId/${file!.name}')
          .putData(fileBytes!);

      if (snapshot.state == TaskState.success) {
        print("SUCCESS");
        document = {
          'classId': classId!,
          'className': title!,
          'topic': topic ?? '',
          'chapters': chapters ?? '',
          'description': description ?? '',
          'eventName': meeting.eventName,
          'from': meeting.from,
          'to': meeting.to,
          'isAllDay': meeting.isAllDay,
          'type': type,
          'fileStoragePath': ['$eventId/${file!.name}'],
          'hasFiles': true
        };
      }
      //print(document);

    } else {
      document = {
        'classId': classId!,
        'className': title!,
        'topic': topic ?? '',
        'chapters': chapters ?? '',
        'description': description ?? '',
        'eventName': meeting.eventName,
        'from': meeting.from,
        'to': meeting.to,
        'isAllDay': meeting.isAllDay,
        'type': type,
        'fileStoragePath': [],
        'hasFiles': false
      };
    }

    print(document);
    var docRef = FirebaseFirestore.instance.doc(eventId!).set(document);
  }
}
