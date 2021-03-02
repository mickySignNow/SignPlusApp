import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/serviceconsumermanagement/v1.dart';
import 'package:googleapis_auth/auth_browser.dart' as auth;
import 'package:googleapis_auth/auth_io.dart';
import 'package:sign_plus/StringNDesigns/Strings.dart';
import 'package:sign_plus/models/AppUser.dart';
import 'package:sign_plus/models/InterData.dart';
import 'package:sign_plus/models/ODMEvent.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/main.dart';
import 'package:sign_plus/models/storage.dart';
import 'package:sign_plus/pages/CallAnswerPage.dart';
import 'package:sign_plus/pages/LoginPageAssest/LoginPageStyle.dart';
import 'package:sign_plus/pages/OnDemandDashboard.dart';
import 'package:sign_plus/pages/WaitingRoom.dart';
import 'package:sign_plus/pages/admin/TabbedAdmin.dart';
import 'package:sign_plus/pages/calendar/create_screen.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';
import 'package:sign_plus/pages/tabbedPage.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/GoogleSignInFunctions.dart';
import 'package:sign_plus/utils/NavigationRoutes.dart';
import 'package:sign_plus/utils/StaticObjects.dart';
import 'package:sign_plus/utils/secrets.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';

import 'admin/AdminPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// firebase auth instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  /// boolean parameters
  /// validate checkbox
  bool _deafCheck = false;
  bool _translatorCheck = false;
  bool _validate = true;
  bool connecting = false;
  bool wrongVerificationCode = false;
  bool phoneConnection = false;
  bool gotSms = false;

  /// textEditing Controllers Email Password SignIn
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final verificationController = TextEditingController();

  ConfirmationResult confirmation;

  bool wrongEmail = false;
  bool emptyEmail = false;

  bool wrongPhone = false;
  bool emptyPhone = false;

  bool wrongPassword = false;
  bool emptyPassword = false;

  // a function who provides a connection to google user
  /**
   * A function to handle GoogleSignIn
   * @params _auth :  FireBaseAuth _auth -  authentication to firebase Instance
   * this method does *double authentication*
   *
   * */

  showadminPasswordDialog({String password, BuildContext context}) async {
    TextEditingController passwordController = TextEditingController();
    bool wrongPW = false;

    await showDialog<String>(
      context: context,
      child: AlertDialog(
        content: Row(
          children: [
            wrongPW
                ? Text(
                    Strings.loginPageAdminWrongPW,
                    style: TextStyle(color: Colors.red),
                  )
                : Text(''),
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: Strings.loginPageAdminTextPW,
                    hintText: Strings.loginPageAdminHintPW),
              ),
            )
          ],
        ),
        actions: [
          new FlatButton(
              child: Text(Strings.CANCEL),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: Text(Strings.APPROVE),
              onPressed: () {
                if (passwordController.text == password) {
                  Navigator.of(context).pushNamed(
                    'Admin',
                  );
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         settings: NavigationRoutes.admintabs,
                  //         builder: (con) => TabbedAdmin(
                  //               initialIndex: 0,
                  //             )));
                } else {
                  setState(() {
                    passwordController.text = Strings.loginPageAdminWrongPW;
                  });
                }
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    FirebaseAnalytics fa = FirebaseAnalytics();
    fa.setAnalyticsCollectionEnabled(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    bool isWeb = (pageWidth > 700);
    //Todo: move all widgets to UI folder and create them methodically
    return Scaffold(
      appBar: buildNavBar(context: context, title: ''),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 24, spreadRadius: 24)
            ],
            color: Color(0xffFAFAFA).withOpacity(0.9),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30),
              Center(
                child: Container(
                  width: isWeb ? pageWidth / 2 + 10 : pageWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// Google signIn button

                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign+',
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        color: Colors.black45,
                                        offset: Offset(2, 2),
                                        blurRadius: 2)
                                  ],
                                  fontFamily: 'alef',
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                            Text(
                              '..לעתיד נגיש יותר',
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        color: Colors.black45,
                                        offset: Offset(3, 2),
                                        blurRadius: 2)
                                  ],
                                  fontFamily: 'alef',
                                  fontSize: 32,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                      phoneConnection
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                LoginPageTextField(
                                  empty: emptyPhone,
                                  wrong: wrongPhone,
                                  inputType: TextInputType.number,
                                  hint: 'הזינו מספר ',
                                  errorMessage: '',
                                  icon: Icon(Icons.phone_android_sharp),
                                  controller: phoneController,
                                ),
                                // TextFormField(
                                //   keyboardType: TextInputType.number,
                                //   controller: phoneController,
                                //   textDirection: TextDirection.ltr,
                                //   textAlign: TextAlign.end,
                                //   decoration: InputDecoration(
                                //       fillColor: Color(0xffFFFFFF),
                                //       suffixIcon:
                                //           Icon(Icons.phone_android_sharp),
                                //       filled: true,
                                //       hintText: 'הזן מספר ',
                                //       hintStyle: TextStyle(fontSize: 14),
                                //       enabledBorder: OutlineInputBorder(
                                //         borderSide:
                                //             BorderSide(color: Colors.black),
                                //         borderRadius:
                                //             BorderRadius.circular(30.0),
                                //       ),
                                //       focusedBorder: OutlineInputBorder(
                                //         borderSide:
                                //             BorderSide(color: Colors.blue),
                                //         borderRadius:
                                //             BorderRadius.circular(30.0),
                                //       )),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                gotSms
                                    ? LoginPageTextField(
                                        controller: verificationController,
                                        icon:
                                            Icon(Icons.confirmation_num_sharp),
                                        errorMessage:
                                            'סיסמא לא נכונה אנא נסה שנית',
                                        hint: 'הזן את הסיסמא שקיבלת לפלאפון ',
                                        inputType: TextInputType.number,
                                        wrong: wrongPassword,
                                        empty: emptyPassword,
                                      )
                                    // TextFormField(
                                    //         keyboardType: TextInputType.number,
                                    //         controller: verificationController,
                                    //         textDirection: TextDirection.ltr,
                                    //         textAlign: TextAlign.end,
                                    //         decoration: InputDecoration(
                                    //             fillColor: Color(0xffFFFFFF),
                                    //             suffixIcon: Icon(
                                    //                 Icons.confirmation_num_sharp),
                                    //             filled: true,
                                    //             hintText:
                                    //                 'הזן את הסיסמא שקיבלת לפלאפון '
                                    //                 ,
                                    //             hintStyle: TextStyle(fontSize: 14),
                                    //             enabledBorder: OutlineInputBorder(
                                    //               borderSide: BorderSide(
                                    //                   color: Colors.black),
                                    //               borderRadius:
                                    //                   BorderRadius.circular(30.0),
                                    //             ),
                                    //             focusedBorder: OutlineInputBorder(
                                    //               borderSide: BorderSide(
                                    //                   color: Colors.blue),
                                    //               borderRadius:
                                    //                   BorderRadius.circular(30.0),
                                    //             )),
                                    //       )
                                    : SizedBox(
                                        height: 5,
                                      ),
                              ],
                            )
                          : Column(
                              children: [
                                LoginPageTextField(
                                  controller: emailController,
                                  icon: Icon(Icons.mail_outline_sharp),
                                  errorMessage:
                                      'מייל לא נכון או לא קיים במערכת',
                                  hint: 'הזן מייל',
                                  inputType: TextInputType.emailAddress,
                                  wrong: wrongEmail,
                                  empty: emptyEmail,
                                ),
                                // Container(
                                //   height: 45,
                                //   margin: EdgeInsets.symmetric(horizontal: 5),
                                //   child: TextFormField(
                                //     keyboardType: TextInputType.emailAddress,
                                //     controller: emailController,
                                //     onChanged: (val) {
                                //       setState(() {
                                //         wrongEmail = false;
                                //       });
                                //     },
                                //     textDirection: TextDirection.ltr,
                                //     textAlign: TextAlign.end,
                                //     decoration: InputDecoration(
                                //         fillColor: Color(0xffFFFFFF),
                                //         suffixIcon: Icon(Icons.email),
                                //         filled: true,
                                //         hintText: 'הזנ/י מייל כאן ',
                                //         hintStyle: TextStyle(fontSize: 14),
                                //         enabledBorder: OutlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //           borderRadius:
                                //               BorderRadius.circular(30.0),
                                //         ),
                                //         focusedBorder: OutlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.blue),
                                //           borderRadius:
                                //               BorderRadius.circular(30.0),
                                //         )),
                                //   ),
                                // ),
                                // Text(
                                //   (wrongEmail)
                                //       ? 'שם משתמש לא נכון או לא קיים במערכת'
                                //       : '',
                                //   style: TextStyle(
                                //       decoration: TextDecoration.none,
                                //       color: Colors.red),
                                // ),
                                LoginPageTextField(
                                  empty: emptyPassword,
                                  wrong: wrongPassword,
                                  inputType: TextInputType.text,
                                  hint: 'הזנ/י סיסמא כאן ',
                                  errorMessage: 'סיסמא שגויה',
                                  icon: Icon(Icons.remove_red_eye),
                                  controller: passwordController,
                                  secureText: true,
                                ),
                                // Container(
                                //   height: 45,
                                //   margin: EdgeInsets.symmetric(
                                //       horizontal: 10, vertical: 5),
                                //   child: TextFormField(
                                //     controller: passwordController,
                                //     onChanged: (val) {
                                //       setState(() {
                                //         wrongPassword = false;
                                //       });
                                //     },
                                //     textAlign: TextAlign.end,
                                //     obscureText:
                                //         (passwordController.text.length > 4)
                                //             ? true
                                //             : false,
                                //     decoration: InputDecoration(
                                //         fillColor: Color(0xffFFFFFF),
                                //         suffixIcon: Icon(Icons.remove_red_eye),
                                //         hintText: 'הזנ/י סיסמא כאן ',
                                //         hintStyle: TextStyle(fontSize: 14),
                                //         filled: true,
                                //         enabledBorder: OutlineInputBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(30.0),
                                //         ),
                                //         focusedBorder: OutlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.blue),
                                //           borderRadius:
                                //               BorderRadius.circular(30.0),
                                //         )),
                                //   ),
                                // ),
                                // Text(
                                //   (wrongPassword) ? 'סיסמא שגויה' : '',
                                //   textAlign: TextAlign.end,
                                //   style: TextStyle(
                                //       decoration: TextDecoration.none,
                                //       color: Colors.red),
                                // )
                              ],
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: connecting
                            ? () {}
                            : phoneConnection
                                ? gotSms
                                    ? () async {
                                        var userCredentials = await confirmation
                                            .confirm(
                                                verificationController.text)
                                            .catchError((e) {
                                          print(e);
                                          if (e.code ==
                                              'invalid-verification-code') {
                                            setState(() {
                                              wrongPassword = true;
                                            });
                                          }
                                        });
                                        if (userCredentials != null) {
                                          setState(() {
                                            connecting = true;
                                          });
                                          var role =
                                              await FirebaseConstFunctions
                                                  .getRoleById({
                                            'uid': FirebaseAuth
                                                .instance.currentUser.uid
                                          });
                                          StaticObjects.uid =
                                              userCredentials.user.uid;
                                          StaticObjects.role = role.data;
                                          Navigator.of(context)
                                              .pushNamed('main');
                                        } else {
                                          print('something went wrong');
                                        }
                                      }
                                    : () {
                                        setState(() async {
                                          gotSms = true;
                                          if (phoneController.text.length > 0) {
                                            confirmation = await FirebaseAuth
                                                .instance
                                                .signInWithPhoneNumber(
                                                    phoneToLocal(
                                                        phoneController.text))
                                                .catchError(
                                                    (e) => print(e.code));
                                            var role =
                                                await FirebaseConstFunctions
                                                    .getRoleById({
                                              'uid': FirebaseAuth
                                                  .instance.currentUser.uid
                                            });
                                            StaticObjects.uid =
                                                _auth.currentUser.uid;
                                            StaticObjects.role = role.data;
                                            Navigator.pushNamed(
                                                context, 'main');
                                          } else {
                                            setState(() {
                                              emptyPhone = true;
                                            });
                                          }
                                        });
                                      }
                                : () async {
                                    setState(() async {
                                      connecting = true;
                                      await _auth
                                          .signInWithEmailAndPassword(
                                              email:
                                                  emailController.text.trim(),
                                              password: passwordController.text
                                                  .trim())
                                          .catchError((e) {
                                        print(e.code);
                                        setState(() {
                                          switch (e.code) {
                                            case 'wrong-password':
                                              wrongEmail = false;
                                              wrongPassword = true;
                                              connecting = false;
                                              break;
                                            case 'user-not-found':
                                              wrongEmail = true;
                                              wrongPassword = false;
                                              connecting = false;
                                              break;
                                            case 'invalid-email':
                                              wrongEmail = true;
                                              wrongPassword = false;
                                              connecting = false;
                                              break;
                                            default:
                                              print(e);
                                          }
                                        });
                                      });
                                      final userCred = _auth.currentUser;
                                      HttpsCallable getRoleById =
                                          FirebaseConstFunctions.getRoleById;
                                      var res = await getRoleById
                                          .call({'uid': userCred.uid});
                                      StaticObjects.uid = userCred.uid;
                                      StaticObjects.role = res.data;
                                      if (res.data == 'inter') {
                                        /// isInterOnDemand
                                        var ODM = await FirebaseFirestore
                                            .instance
                                            .collection('inters-data')
                                            .doc(_auth.currentUser.uid)
                                            .get();
                                        print(ODM.data());
                                        print(ODM.data()['onDemand']);
                                        if (ODM.data()['onDemand']) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (co) =>
                                                      OnDemandDashboard()));
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed('main');
                                        }
                                      } else {
                                        Navigator.of(context).pushNamed('main');
                                      }
                                    });
                                  },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          // margin: isWeb
                          //     ? EdgeInsets.fromLTRB(
                          //         MediaQuery.of(context).size.width / 4,
                          //         16,
                          //         MediaQuery.of(context).size.width / 4,
                          //         0)
                          //     : EdgeInsets.symmetric(
                          //         horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue),
                          child: connecting
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  phoneConnection
                                      ? gotSms
                                          ? 'כניסה'
                                          : 'לקבלת סיסמא לנייד'
                                      : 'כניסה',
                                  style: homePageText(isWeb ? 18 : 12,
                                      Colors.white, FontWeight.bold),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      RaisedButton(
                          child: Text(phoneConnection
                              ? 'לכניסה עם מייל וסיסמא'
                              : 'לכניסה עם פלאפון'),
                          onPressed: () {
                            setState(() {
                              phoneConnection = !phoneConnection;
                            });
                          }),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     SizedBox(
                      //       width: 15,
                      //     ),
                      //     Text(
                      //       'שכחתי סיסמא',
                      //       // textAlign: TextAlign.end,
                      //       style: homePageText(
                      //           12, Colors.lightBlue, FontWeight.normal),
                      //     ),
                      //     SizedBox(
                      //       width: 15,
                      //     ),
                      //   ],
                      // ),

                      // Row(
                      //   children: [
                      //     InkWell(
                      //       onTap: () => showadminPasswordDialog(
                      //           password: '1234', context: context),
                      //       child: Container(
                      //         child: Text(
                      //           'ADMIN',
                      //           style: TextStyle(decoration: TextDecoration.none),
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
