import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/admin/AdminPage.dart';
import 'package:sign_plus/resources/color.dart';

/**
 * builder for app's top navbar
 * */
PreferredSize buildNavBar(
    {@required BuildContext context, @required String title, String role}) {
  return new PreferredSize(
    child: new Container(
      padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new Padding(
        padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: homePageText(14, Colors.white, FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
              child: Image.asset(
                'images/sign+_white.png',
                height: 40,
              ),
            ),
            Text(
              role ?? "",
              style: homePageText(14, Colors.white, FontWeight.normal),
            )
          ],
        ),
      ),
      decoration: new BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff9AB7D0), Color(0xff004E98), Color(0xff0F122A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey[500],
              blurRadius: 20.0,
              spreadRadius: 1.0,
            )
          ]),
    ),
    preferredSize: new Size(MediaQuery.of(context).size.width, 150.0),
  );
}

/**
  * the style of the front page text
  * */
TextStyle homePageText(double size, Color textColor, FontWeight weight) {
  return TextStyle(
      decoration: TextDecoration.none,
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: size);
}

class AlertWithButtonsWidget extends State {
  String date;
  String hour;
  String time;
  String name;

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Dialog Title Text.'),
          content: Text("Are You Sure Want To Proceed ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () => showAlert(context),
          child: Text('Click Here To Show Alert Dialog Box'),
          textColor: Colors.white,
          color: Colors.purple,
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        ),
      ),
    );
  }
}

Container emailPwTemplate(BuildContext context,
    TextEditingController controller, String hint, Icon icon) {
  return Container(
    height: 45,
    margin: kIsWeb
        ? EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 4, 16,
            MediaQuery.of(context).size.width / 4, 0)
        : EdgeInsets.symmetric(horizontal: 30, vertical: 4),
    child: TextFormField(
      controller: controller,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
          fillColor: Color(0xffFFFFFF),
          suffixIcon: icon,
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30.0),
          )),
    ),
  );
}

InkWell confirmationButton(
    {BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    FirebaseAuth auth,
    String text,
    Function onTap}) {
  return InkWell(
    onTap: () {
      onTap();
      // auth
      //     .createUserWithEmailAndPassword(
      //         email: emailController.text, password: passwordController.text)
      //     .then((userCred) {
      //   userCred.user.updateProfile(displayName: 'user');
      //   Navigator.pushReplacement(context, route);
      // });
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      margin: kIsWeb
          ? EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 4, 16,
              MediaQuery.of(context).size.width / 4, 0)
          : EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.blue),
      child: Text(
        text,
        style: homePageText(18, Colors.white, FontWeight.bold),
      ),
    ),
  );
}

adminTextField(
    {StatefulWidget main,
    TextEditingController controller,
    dynamic textInput,
    bool filled,
    String hint,
    String errorMessage,
    TextInputType inputType}) {
  return Column(
    children: [
      TextField(
        keyboardType: inputType,
        textAlign: TextAlign.end,
        enabled: true,
        // cursorColor: CustomColor.sea_blue,
        controller: controller,
        // textCapitalization: TextCapitalization.sentences,
        // textInputAction: TextInputAction.next,
        onChanged: (value) {
          main.createState().setState(() {
            textInput = controller.text;
            filled = true;
          });
        },
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
            fillColor: Color(0xffFFFFFF),
            suffixIcon: Icon(Icons.format_textdirection_r_to_l),
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(30.0),
            )),
        // decoration: new InputDecoration(
        //   disabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     borderSide: BorderSide(color: Colors.grey, width: 1),
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     borderSide: BorderSide(color: CustomColor.sea_blue, width: 1),
        //   ),
        //   focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     borderSide: BorderSide(color: CustomColor.dark_blue, width: 2),
        //   ),
        //   errorBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     borderSide: BorderSide(color: Colors.redAccent, width: 2),
        //   ),
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //   ),
        //   hintText: hint,
        //   hintStyle: TextStyle(fontSize: 14),
        // ),
      ),
      Text(
        (filled) ? '' : errorMessage,
        style: TextStyle(decoration: TextDecoration.none, color: Colors.red),
      )
    ],
  );
}

informationAlertDialog(
    BuildContext context, String message, String textButton) async {
  Timer timer = Timer(Duration(seconds: 3), (() async {
    return await showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(textButton),
            )
          ],
        );
      },
    );
  }));
}
