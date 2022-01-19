import 'package:flutter/material.dart';
import 'package:simpleschool/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: Padding(
        padding: EdgeInsets.all(32),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 300,
            minWidth: 100,
            maxHeight: double.infinity,
            maxWidth: double.infinity,
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              FlutterLogo(size: 120),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Text("Welcome Back",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                child: Text("Sign up with Google"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  minimumSize: Size(double.infinity, 40),
                ),
              ),
              SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  children: [
                    TextSpan(
                        text: "Log in",
                        style: TextStyle(decoration: TextDecoration.underline)),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      //GoogleSignupButtonWidget(),
    );
  }
}
