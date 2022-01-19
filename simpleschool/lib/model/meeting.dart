import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;

  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  // @override
  // void setStartTime(DateTime input, int index) {
  //   appointments;
  // }
}

Color randomOpaqueColor() {
  return Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
}
