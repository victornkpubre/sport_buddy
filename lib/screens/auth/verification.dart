

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_buddy/screens/auth/auth.dart';

class VerificationPage extends StatefulWidget {
  User user;
  VerificationPage({
    super.key,
    required this.user
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {


  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text("You need to Verify Your Email", style: TextStyle(fontSize: 18)),
            Text("Check your email for a verification link, follow the link and you will be verified"),
            SizedBox(height: 20),
            TextButton(
              onPressed: (){
                if(user != null){
                  user.sendEmailVerification();
                  showAppDialog("Verification", "Verification Email Sent", (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => AuthPage()
                    ));
                  });
                }
              }, 
              child: Text("Resend Verification Link") 
            ),
            Text("Didn't get the Link,\n Check your spam folder or Resend the link", textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  void showAppDialog(String title, String message, VoidCallback callback) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message)
          ],
        ),
        actions: [
          TextButton(
            child: Text("Done"),
            onPressed: callback,
          )
        ],
      )
    );
  }
}