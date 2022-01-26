import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:intl/intl.dart';


class Class{
  String documentId;
  String name;
  String courseId;
  String profName;
  String profEmail;
  Map<String,dynamic> meetingSchedule;
  Map meetingTime;
  String courseDescription;
  Timestamp startDate;
  Timestamp endDate;
  String university; // change to its own object 

  Class(this.documentId, this.name, this.courseId, this.profName, this.profEmail, this.meetingSchedule, this.meetingTime, this.courseDescription, this.university, this.startDate, this.endDate);
  
  String getId() {return documentId;}
  String getName(){return name;}
  String getCourseId(){return courseId;}
  String getProfName(){return profName;}
  String getProfEmail(){return profEmail;}
  String getCourseDescription(){return courseDescription;}
  Map<String, dynamic> getMeetingSchedule() {return meetingSchedule;}
  String getUni(){return university;}
  Map  getMeetingTime() {return meetingTime;}
  DateTime getStartDateAsDateTime(){
    return DateTime.fromMillisecondsSinceEpoch(startDate.seconds * 1000);
  }
  DateTime getEndDateAsDateTime(){
    return DateTime.fromMillisecondsSinceEpoch(endDate.seconds * 1000);
  }

  String getStartDateAsStr(){
    DateTime tmp = DateTime.fromMillisecondsSinceEpoch(startDate.seconds * 1000);
    String formattedDate = DateFormat('MM-dd-yyyy').format(tmp);
    return formattedDate;
  }

  String getEndDateAsStr(){
    DateTime tmp = DateTime.fromMillisecondsSinceEpoch(endDate.seconds * 1000);
    String formattedDate = DateFormat('MM-dd-yyyy').format(tmp);
    return formattedDate;
  }
  void printClass() {
    print("documentId: $documentId");
    print("course name: $name");
    print("courseId: $courseId");
  }

  }