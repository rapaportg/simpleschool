import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

Color _getColor(int index) {
  return colors[index];
}

class ClassDetailsWidget extends StatelessWidget {
  String classId;

  ClassDetailsWidget({Key? key, required this.classId}) : super(key: key);

  // String? _className;
  // String? _professor;
  // String? _profEmail;
  // String? _ta;
  // String? _taEmail;
  // int? _color;
  // DateTime? _startDate;
  // DateTime? _endDate;
  // Map<String, dynamic>? _meetingSchedule;
  // Map<String, dynamic>? _meetingTimes;

  Future<Map<String, dynamic>> _getClassDetails() async {
    var classSnapshot =
        await FirebaseFirestore.instance.doc('classes/${classId}').get();

    var _className = classSnapshot.data()!['name'];
    var _color = classSnapshot.data()!['color'];
    var _startDate = DateTime.fromMillisecondsSinceEpoch(
        classSnapshot.data()!['start_date'].seconds * 1000);
    var _endDate = DateTime.fromMillisecondsSinceEpoch(
        classSnapshot.data()!['end_date'].seconds * 1000);
    var _meetingTimes = classSnapshot.data()!['meeting_time'];
    var _meetingSchedule = classSnapshot.data()!['meeting_schedule'];
    var _professor = classSnapshot.data()!['professor'];
    var _profEmail = classSnapshot.data()!['prof_email'];
    var _ta = classSnapshot.data()!['ta'];
    var _taEmail = classSnapshot.data()!['ta_email'];
    var _courseId = classSnapshot.data()!['course_id'];

    return {
      'className': _className,
      'color': _color,
      'startDate': _startDate,
      'endDate': _endDate,
      'meetingTimes': _meetingTimes,
      'meetingSchedule': _meetingSchedule,
      'professor': _professor,
      'profEmail': _profEmail,
      'ta': _ta,
      'taEmail': _taEmail,
      'courseId': _courseId
    };
  }

  Widget _contactsRow(String type, String name, String email) {
    if (name == '') {
      return Container();
    } else {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${type}: "),
            Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 0)),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
            ),
            Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 0)),
            Text(
              email,
              style: TextStyle(color: Colors.blue.shade700),
            ),
            IconButton(
              iconSize: 14,
              color: Colors.blue.shade700,
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text: "${email}",
                ));
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _meetingSchedule(Map<String, dynamic> meetingSchedule) {
    return Container(
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children: [
          Text("Meeting Schedule: "),
          Container(
            alignment: Alignment.center,
            width: 90,
            height: 30,
            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
            decoration: BoxDecoration(
                color: meetingSchedule['monday']
                    ? Colors.blue.shade400
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Text(
              "Monday",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 90,
            height: 30,
            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
            decoration: BoxDecoration(
                color: meetingSchedule['tuesday']
                    ? Colors.blue.shade400
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Text("Tuesday", style: TextStyle(color: Colors.white)),
          ),
          Container(
            alignment: Alignment.center,
            width: 90,
            height: 30,
            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
            decoration: BoxDecoration(
                color: meetingSchedule['wednesday']
                    ? Colors.blue.shade400
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child:
                const Text("Wednesday", style: TextStyle(color: Colors.white)),
          ),
          Container(
            alignment: Alignment.center,
            width: 90,
            height: 30,
            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
            decoration: BoxDecoration(
                color: meetingSchedule['thursday']
                    ? Colors.blue.shade400
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child:
                const Text("Thursday", style: TextStyle(color: Colors.white)),
          ),
          Container(
              alignment: Alignment.center,
              width: 90,
              height: 30,
              margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
              decoration: BoxDecoration(
                  color: meetingSchedule['friday']
                      ? Colors.blue.shade400
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Text(
                "Friday",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  Widget _meetingTime(dynamic time, BuildContext context) {
    TimeOfDay start =
        TimeOfDay(hour: time['start']['hour'], minute: time['start']['minute']);
    TimeOfDay end =
        TimeOfDay(hour: time['end']['hour'], minute: time['end']['minute']);
    //return Text("Class time:    ${start.format(context)} to ${end.format(context)}");
    return Container(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 12),
      child: Row(
        children: [
          Text("Class Time: "),
          Text(
            "${start.format(context)}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(" to "),
          Text(
            "${end.format(context)}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _className(String name, String id, BuildContext context) {
    return Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          child: Row(children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade700),
        ),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      content: Padding(
                        padding: const EdgeInsets.all(8),
                        // need to updte to accept class
                        child: Text("test"),
                      ),
                    );
                  });
            },
            icon: Icon(
              Icons.settings,
              color: Colors.blueGrey.shade700,
            )),
      ])),
      Text(id)
    ]));
  }

  @override
  Widget build(BuildContext context) {
    //_getClassDetails();
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: FutureBuilder(
            future: _getClassDetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return (Center(
                  child: CircularProgressIndicator(),
                ));
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Snapshot Error"));
                } else if (snapshot.hasData && snapshot.data!.length > 0) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _className(snapshot.data!['className'],
                            snapshot.data!['courseId'], context),
                        Divider(color: Colors.blueGrey),
                        _contactsRow(
                          "Professor",
                          snapshot.data!['professor'],
                          snapshot.data!['profEmail'],
                        ),
                        _contactsRow("TA", snapshot.data!['ta'],
                            snapshot.data!['taEmail']),
                        _meetingTime(snapshot.data!['meetingTimes'], context),
                        _meetingSchedule(snapshot.data!['meetingSchedule']),
                      ]);
                } else {
                  print("empty data");
                  return Text("empty data");
                }
              }
              return Text("Testing");
            },
          )),
    );
  }
}
