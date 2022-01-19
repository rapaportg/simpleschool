import 'package:simpleschool/utils.dart';
import 'dart:core';
import 'package:flutter/material.dart';

class EntryField {
  static const createdTime = 'createdTime';
}

class Entry {
  DateTime createdTime;
  String id;
  String title;
  String type; // Class, hmwk, quiz, exam
  String classId;
  DateTime dueDate;
  bool eventOrItem;
  DateTime endTime;
  bool isDone;

  Entry({
    this.createdTime = DateTime.now(),
    this.title,
    this.type = '',
    this.id,
    this.classId,
    this.dueDate,
    this.endTime,
    this.eventOrItem,
    this.isDone = false,
  });

  static Entry fromJson(Map<String, dynamic> json) => Entry(
      createdTime: Utils.toDateTime(json['createdTime']),
      title: json['title'],
      type: json['type'],
      classId: json['classId'],
      dueDate: Utils.toDateTime(json['dueDate']),
      endTime: Utils.toDateTime(json['endTime']),
      eventOrItem: json['eventOrItem'],
      isDone: json['isDone']);

  Map<String, dynamic> toJson() => {
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'title': title,
        'type': type,
        'classId': classId,
        'dueDate': Utils.fromDateTimeToJson(dueDate),
        'endTime': Utils.fromDateTimeToJson(endTime),
        'eventOrItem': eventOrItem,
        'isDone': isDone
      };
}
