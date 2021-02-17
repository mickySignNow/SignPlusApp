import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/LoginPage.dart';

class LogOutPage extends StatefulWidget {
  FirebaseAuth auth;
  LogOutPage({@required this.auth});
  @override
  _LogOutPageState createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  logOut() async {
    await widget.auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (con) => LoginPage()));
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1500), () {
      logOut();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Image.asset('images/waving.gif'));
  }
}
