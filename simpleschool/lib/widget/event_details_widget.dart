import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventDetailsWidget extends StatelessWidget {
  final User user;
  DocumentReference eventRef;
  DocumentSnapshot eventSnapshot;

  EventDetailsWidget(
      {Key? key,
      required this.user,
      required this.eventRef,
      required this.eventSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(eventSnapshot['eventName']);
    // Todo: [] title
    //       [] time
    //       [] description
    //       [] pdf reader
    //       [] discussion board
    //       [] ability to edit
    // -----------------------------------------
    return Container(
      width: MediaQuery.of(context).size.width*0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eventSnapshot['eventName']),
        Text(eventSnapshot['className']),
      ],
    ));
  }
}
