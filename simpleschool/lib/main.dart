import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simpleschool/pages/homepage.dart';
import 'package:provider/provider.dart';
import 'package:simpleschool/widget/sign_up_widget.dart';
import 'package:simpleschool/provider/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          //debugShowMaterialGrid: true,
          theme: ThemeData.light(),
          home: HomePage(),
        ),
      );
}
