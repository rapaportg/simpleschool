import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simpleschool/pages/homepage.dart';
import 'package:provider/provider.dart';
import 'package:simpleschool/widget/sign_up_widget.dart';
import 'package:simpleschool/provider/google_sign_in.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_utils/intl_utils.dart';
import 'package:intl/date_symbol_data_local.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          supportedLocales: [
            Locale('de'),
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('it'),
          ],
          localizationsDelegates: [
            //GlobalMaterialLocalizations.delegate,
            //GlobalWidgetsLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],

          //debugShowMaterialGrid: true,
          theme: ThemeData.light(),
          home: HomePage(),
        ),
      );
}
