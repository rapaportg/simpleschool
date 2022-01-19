import 'package:flutter/material.dart';
import 'package:simpleschool/widget/sign_up_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simpleschool/widget/logged_in_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "  Simple School",
            style: TextStyle(fontSize: 16),
          ),
          toolbarHeight: 32,
        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return UserLoggedInWidget();
              } else if (snapshot.hasError) {
                return Center(child: Text("Something Went Wrong!"));
              } else {
                return SignUpWidget();
              }
            }),
      );
}
