import 'package:flutter/material.dart';
import 'package:simpleschool/widget/sign_up_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simpleschool/widget/logged_in_widget.dart';

class HomePage extends StatelessWidget {
  // Future logout() async {
  //   await _firebaseAuth.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()),(route) => false)));
  // }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: false,
          title: Text(
            "  Simple School",
            style: TextStyle(fontSize: 16),
          ),
          toolbarHeight: 36,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Show Snackbar',
              onPressed: () {
                FirebaseAuth.instance.signOut();
                //Navigator.of(context).pop();
              },
            ),
          ],
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
