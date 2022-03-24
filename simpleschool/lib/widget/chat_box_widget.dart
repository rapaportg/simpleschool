import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChatBoxWidget extends StatefulWidget {
  String chatId;
  User user;
  ChatBoxWidget({Key? key, required this.chatId, required this.user})
      : super(key: key);

  @override
  State<ChatBoxWidget> createState() => _ChatBoxWidgetState(user);
}

class _ChatBoxWidgetState extends State<ChatBoxWidget> {
  User user;
  final _formKey = GlobalKey<FormBuilderState>();
  _ChatBoxWidgetState(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
          child: Column(
        children: [
          Expanded(
            // Message History
            flex: 9,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  color: Colors.purple.shade200,
                  ),
                  ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                  //color: Colors.amber,
                  child: Row(
                    children: [
                      Expanded(
                        // Chat input
                        flex: 7,
                        child: Container(
                            //color: Colors.pink,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8,16,8,16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: FormBuilder(
                                    key: _formKey,
                                    child: FormBuilderTextField(
                                      name: 'msg',
                                      decoration: const InputDecoration(
                                        helperMaxLines: 10,
                                        contentPadding: EdgeInsets.all(4)
                                      
                                      ),
                                    ),
                                ),
                              ),
                            )),
                      ),
                      Expanded(
                        // Chat send
                        flex: 2,
                        child: Container(
                         // color: Colors.purple,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              alignment: Alignment.center,
                              //color: Colors.yellowAccent,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Send", style: TextStyle(fontSize: 16),),
                                 // fontWeight: FontWeight.bold,
                                ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    
                    ],
                  ))),
        ],
      )),
    );
  }
}
