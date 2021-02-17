import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/StringNDesigns/Strings.dart';
import 'package:sign_plus/models/ODMEvent.dart';
import 'package:sign_plus/pages/WaitingRoom.dart';
import 'package:sign_plus/pages/admin/AdminPage.dart';
import 'package:sign_plus/pages/calendar/create_screen.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';
import 'package:sign_plus/resources/color.dart';
import 'package:uuid/uuid.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'FirebaseConstFunctions.dart';

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

class StateFullDialog extends StatefulWidget {
  @override
  _StateFullDialogState createState() => _StateFullDialogState();
}

class _StateFullDialogState extends State<StateFullDialog> {
  String name = '', title = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Map<String, String> nameTitle = {'': ''};
  bool didChangeName = true;
  bool didChangeTitle = true;
  bool isEditing = false;

  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    MediaQuery.of(context).viewInsets;

    return AlertDialog(
      // insetPadding: EdgeInsets.symmetric(
      //      vertical: isEditing   ? 0 : pageHeight / 4),
      title: Text(Strings.onDemandEnterNameAndTitle),
      content: Column(
        children: [
          Text(
            Strings.onDemandTextEnterName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            onChanged: (value) {
              setState(() {
                isEditing = true;
              });

              didChangeName = true;
              name = value;
            },
            onEditingComplete: () => isEditing = false,
            controller: nameController,
            decoration: InputDecoration(
              hintText: Strings.onDemandHintEnterName,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          didChangeName
              ? SizedBox(
                  height: 5,
                )
              : Text(
                  'אנא הזינו שם',
                  style: TextStyle(color: Colors.red),
                ),
          Text(
            'הזינו תיאור לשיחה ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                isEditing = true;
              });
              didChangeTitle = true;
              title = value;
            },
            onEditingComplete: () => isEditing = false,
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'תיאור השיחה ',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          didChangeTitle
              ? SizedBox(
                  height: 5,
                )
              : Text(
                  'אנא הזינו תיאור לפגישה',
                  style: TextStyle(color: Colors.red),
                ),
          SizedBox(height: 10),
          RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: inProgress ? CircularProgressIndicator() : Text('הזמנה'),
            onPressed: inProgress
                ? () {}
                : () {
                    setState(() {
                      inProgress = true;
                      if (nameController.text != '' && name != '')
                        nameTitle['name'] = name;
                      else {
                        didChangeName = false;
                      }
                      if (titleController.text != '' && title != '')
                        nameTitle['title'] = title;
                      else {
                        didChangeTitle = false;
                      }
                      if (nameTitle['name'] != null &&
                          nameTitle['title'] != null) {
                        final uuid = Uuid();
                        ODMEvent event = ODMEvent(
                            title: nameTitle['title'],
                            customerName: nameTitle['name'],
                            link:
                                'https://signowvideo.web.app/?roomName=${uuid.v1().substring(0, 8)}');
                        final createODMEvent =
                            FirebaseConstFunctions.createODMEvent;
                        createODMEvent.call(event.toJson()).whenComplete(() =>
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (con) =>
                                        WaitingRoom(event: event))));
                      }
                    });
                  },
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ביטול'),
        )
      ],
    );
  }
}

class SideTabscollapse extends StatefulWidget {
  int initialIndex;
  String role;
  String uid;
  SideTabscollapse(
      {@required this.initialIndex, @required this.role, @required this.uid});
  final GlobalKey containerKey = GlobalKey();

  @override
  _SideTabscollapseState createState() => _SideTabscollapseState();
}

class _SideTabscollapseState extends State<SideTabscollapse> {
  bool isSideBarOpenned = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          top: 0,
          bottom: 0,
          left: isSideBarOpenned ? 0 : -screenWidth,
          right: isSideBarOpenned ? 0 : screenWidth,
          duration: Duration(milliseconds: 400),
          child: AnimatedOpacity(
            opacity: isSideBarOpenned ? 0.9 : 00,
            duration: Duration(milliseconds: 500),
            child: Container(
              color: Color(0xff008eff),
            ),
          ),
        ),
        AnimatedPositioned(
          top: 0,
          bottom: 0,
          left: isSideBarOpenned ? 0 : -screenWidth,
          right: isSideBarOpenned ? 0 : screenWidth - 125,
          duration: Duration(milliseconds: 500),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    VerticalTabs(
                        key: widget.containerKey,
                        initialIndex: widget.initialIndex ?? 0,
                        direction: TextDirection.rtl,
                        tabBackgroundColor: Colors.blue.withOpacity(0.3),
                        tabTextStyle: TextStyle(color: Colors.white),
                        tabs: (widget.role == 'customer')
                            ? <Tab>[
                                Tab(
                                  text: 'הזמן תור',
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                ),
                                Tab(
                                    text: 'תורים שנקבעו',
                                    icon: Icon(Icons.calendar_today)),
                                Tab(
                                    text: 'תורים שהוזמנו',
                                    icon: Icon(Icons.calendar_today)),
                                Tab(
                                    text: 'היסטוריית שיחות',
                                    icon: Icon(Icons.history))
                              ]
                            : <Tab>[
                                Tab(
                                    text: 'לוח הזמנות',
                                    icon: Icon(Icons.dashboard)),
                                Tab(
                                    text: 'תורים שנקבעו',
                                    icon: Icon(Icons.calendar_today)),
                                Tab(
                                    text: 'היסטוריית שיחות',
                                    icon: Icon(Icons.history))
                              ],
                        contents: (widget.role == 'customer')
                            ? [
                                CreateScreen(),
                                DashboardScreen(
                                    uid: widget.uid,
                                    role: widget.role,
                                    query: 'booked',
                                    title: 'תורים שנקבעו'),
                                DashboardScreen(
                                    uid: widget.uid,
                                    role: widget.role,
                                    query: 'pending',
                                    title: 'תורים שהוזמנו'),
                                DashboardScreen(
                                    uid: widget.uid,
                                    role: widget.role,
                                    query: 'history',
                                    title: 'היסטוריית שיחות')
                              ]
                            : [
                                DashboardScreen(
                                    uid: widget.uid,
                                    role: widget.role,
                                    query: 'requests',
                                    title: 'לוח הזמנות'),
                                DashboardScreen(
                                    uid: widget.uid,
                                    role: widget.role,
                                    query: 'booked',
                                    title: 'תורים שנקבעו'),
                                DashboardScreen(
                                    uid: widget.uid,
                                    role: widget.role,
                                    query: 'history',
                                    title: 'היסטוריית שיחות')
                              ])
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isSideBarOpenned = !isSideBarOpenned;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    width: 45,
                    height: 50,
                    child:
                        isSideBarOpenned ? Icon(Icons.clear) : Icon(Icons.menu),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 80,
              // )
            ],
          ),
        ),
      ],
    );
  }
}
