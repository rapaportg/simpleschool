import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:simpleschool/model/event.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pdfx/pdfx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:simpleschool/widget/pdf_viewer.dart';

import 'package:simpleschool/widget/chat_box_widget.dart';

class EventDetailsWidget extends StatefulWidget {
  final User user;
  final Event event;

  const EventDetailsWidget({Key? key, required this.user, required this.event})
      : super(key: key);

  @override
  _EventDetailsWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _EventDetailsWidgetState(event, user);
}

class _EventDetailsWidgetState extends State<EventDetailsWidget> {
  Event event;
  User user;
  String addFileButtonText = 'Add File';

  _EventDetailsWidgetState(this.event, this.user);

  final _formKey = GlobalKey<FormBuilderState>();

  Widget updateEvent(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: Text(event.title!),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.95,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(4),
              color: Colors.white,
              child: Column(children: [
                FormBuilder(
                  autoFocusOnValidationFailure: true,
                  key: _formKey,
                  child: SingleChildScrollView(
                    //controller: controller,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilderChoiceChip(
                            name: 'type',
                            decoration: InputDecoration(
                              labelText: 'What type of class is it?',
                            ),
                            options: [
                              FormBuilderFieldOption(
                                  value: 'class', child: Text('Lecture')),
                              FormBuilderFieldOption(
                                  value: 'exam', child: Text('Exam')),
                              FormBuilderFieldOption(
                                  value: 'quiz', child: Text('Quiz')),
                            ],
                          ),
                          FormBuilderTextField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.words,
                            enableInteractiveSelection: true,
                            name: 'topic',
                            initialValue: event.getTopic(),
                            decoration: const InputDecoration(
                              labelText: 'What is the topic of todays class?',
                            ),
                            //validator: FormBuilderValidators.required(context),
                          ),
                          FormBuilderTextField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.words,
                            enableInteractiveSelection: true,
                            name: 'chapters',
                            initialValue: event.getChapters(),
                            decoration: const InputDecoration(
                                labelText:
                                    'What chapters are covered this class?',
                                hintText: "comma seperated list"),
                            //validator: FormBuilderValidators.required(context),
                          ),
                          FormBuilderTextField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.words,
                            enableInteractiveSelection: true,
                            maxLines: 10,
                            initialValue: event.getDescription(),
                            name: 'description',
                            decoration: const InputDecoration(
                              labelText: 'A useful textfield',
                            ),
                            //validator: FormBuilderValidators.required(context),
                          ),
                        ]),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: ElevatedButton(
                      child: Text(addFileButtonText),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          if (result != null) {
                            PlatformFile file = result.files.first;

                            // print(file.name);
                            // print(file.bytes);
                            // print(file.size);
                            // print(file.extension);
                            event.setFile(file);
                            //print(file.path); Cannot use path for web

                            if (result != null) {
                              //=============Use this to upload to storage later =================
                              // Uint8List fileBytes = result.files.first.bytes;
                              // String fileName = result.files.first.name;

                              // // Upload file
                              // await FirebaseStorage.instance
                              //     .ref('uploads/$fileName')
                              //     .putData(fileBytes);
                              //==================================================================
                            }
                            event.updateEventDetailsInFirebase();
                          } else {
                            // User canceled the picker
                          }
                        } else {
                          // User canceled the picker
                        }
                        print(event.file!.name);
                      },
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Spacer(),
                      ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onPressed: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            //print(_formKey.currentState!.value);
                            if (_formKey.currentState!.value['chapters'] !=
                                null) {
                              event.setChapters(
                                  _formKey.currentState!.value['chapters']);
                            }
                            if (_formKey.currentState!.value['type'] != null) {
                              event.setType(
                                  _formKey.currentState!.value['type']);
                            }
                            if (_formKey.currentState!.value['topic'] != null) {
                              event.setTopic(
                                  _formKey.currentState!.value['topic']);
                            }

                            if (_formKey.currentState!.value['description'] !=
                                null) {
                              event.setDescription(
                                  _formKey.currentState!.value['description']);
                            }

                            event.updateEventDetailsInFirebase();
                          } else {
                            print("validation failed");
                          }

                          Navigator.of(context).pop();
                          // reload user_class_list and calendar
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //         duration: Duration(seconds: 4),
                          //         content: Text('I dont work yet!')));
                        },
                      ),
                      Spacer(),
                    ]),
              ]),
            )));
  }

  @override
  Widget build(BuildContext context) {
    print("hit 1");
    // Todo: [X] title
    //       [] time
    //       [] description
    //       [] pdf reader
    //       [] discussion board
    //       [Sorta there] ability to ediy
    // -----------------------------------------
    // print('demo_data/' + event.getFilePath());

    // Widget _pdfViewer = Text("No files added");
    // if (event.hasFiles) {
    //   _pdfViewer = PdfViewerWidget(event: event);
    // }

    var date = event.eventId!.split('/').last.split('-');
    var date_fixed = date[1] + '/' + date[2] + '/' + date[0];

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            appBar: AppBar(
                title: Column(children: [
                  Text(event.title!, style: TextStyle(fontSize: 16)),
                  Text(
                    event.getTopic(),
                    style: TextStyle(fontSize: 12),
                  ),
                ]),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: 'Update event details',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              content: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: updateEvent(context),
                              ),
                            );
                          });
                      // handle the press
                    },
                  )
                ]),
            body: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text(event.getTopic()),

                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: SelectableText(event.description!),
                          ),
                        ),
                        Row(children: [
                          Expanded(
                              flex: 3,
                              child: Container(
                                  color: Colors.blue.shade200,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.7,
                                  child: Center(
                                      child: Text(
                                          "A lecture PDF should go here")))),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  color: Colors.blue.shade100,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child:
                                      ChatBoxWidget(chatId: 'test', user: user,),))
                                      //Center(child: Text("Chat goes here")))),
                        ]),
                      ],
                    )))));
  }
}
