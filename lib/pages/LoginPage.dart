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
import 'package:sign_plus/models/AppUser.dart';
import 'package:sign_plus/models/InterData.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/main.dart';
import 'package:sign_plus/pages/CallAnswerPage.dart';
import 'package:sign_plus/pages/admin/TabbedAdmin.dart';
import 'package:sign_plus/pages/calendar/create_screen.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';
import 'package:sign_plus/pages/tabbedPage.dart';
import 'package:sign_plus/utils/GoogleSignInFunctions.dart';
import 'package:sign_plus/utils/NavigationRoutes.dart';
import 'package:sign_plus/utils/secrets.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:cloud_functions/cloud_functions.dart';

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

  /// textEditing Controllers Email Password SignIn
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool wrongEmail = false;
  bool wrongPassword = false;

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
                    'אנא הזן סיסמא נכונה או לחץ בטל לחזרה',
                    style: TextStyle(color: Colors.red),
                  )
                : Text(''),
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: 'הזן סיסמא', hintText: 'ADMINS PASSWORD'),
              ),
            )
          ],
        ),
        actions: [
          new FlatButton(
              child: const Text('בטל'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('אישור'),
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
                    passwordController.text =
                        ' אנא הזן סיסמא נכונה או לחץ בטל לחזרה';
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
        child: SingleChildScrollView(
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
                // Column(
                //   children: [
                //     Center(
                //       child: Container(
                //         margin: kIsWeb
                //             ? EdgeInsets.fromLTRB(
                //                 MediaQuery.of(context).size.width / 4,
                //                 16,
                //                 MediaQuery.of(context).size.width / 4,
                //                 0)
                //             : EdgeInsets.fromLTRB(20, 16, 15, 0),
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(25),
                //             color: Color(0xffFFFFFF)),
                //         child: CheckboxListTile(
                //           title: Text(
                //             'אני חירש.ת ',
                //             textAlign: TextAlign.center,
                //           ),
                //           secondary: Image.asset(
                //             'images/Ear Icon.png',
                //             height: 35,
                //           ),
                //           subtitle: !_validate
                //               ? Text(
                //                   'אנא סמנ/י',
                //                   style: homePageText(
                //                       12, Colors.red, FontWeight.normal),
                //                 )
                //               : null,
                //           activeColor: Colors.blue,
                //           value: _deafCheck,
                //           onChanged: (value) {
                //             setState(() {
                //               _translatorCheck = !value;
                //               _deafCheck = value;
                //             });
                //           },
                //         ),
                //       ),
                //     ),
                //     Container(
                //       margin: kIsWeb
                //           ? EdgeInsets.fromLTRB(
                //               MediaQuery.of(context).size.width / 4,
                //               16,
                //               MediaQuery.of(context).size.width / 4,
                //               0)
                //           : EdgeInsets.fromLTRB(20, 8, 15, 0),
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(25),
                //           color: Color(0xffFFFFFF)),
                //
                //       /// checkBox "אני מתורגמן"
                //       child: CheckboxListTile(
                //         title: Text(
                //           'אני מתורגמנ.ית ',
                //           textAlign: TextAlign.center,
                //         ),
                //         secondary: Image.asset(
                //           'images/Translator Icon.png',
                //           height: 35,
                //         ),
                //         subtitle: !_validate
                //             ? Text(
                //                 'אנא סמנ/י',
                //                 style: homePageText(
                //                     12, Colors.red, FontWeight.normal),
                //               )
                //             : null,
                //         activeColor: Colors.blue,
                //         value: _translatorCheck,
                //         onChanged: (value) {
                //           setState(() {
                //             _deafCheck = !value;
                //             _translatorCheck = value;
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),

                SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// Google signIn button
                    // InkWell(
                    //   onTap: () {
                    //     setState(() {
                    //       /// check if no checkbox pressed --> make validate false and show error
                    //
                    //       GoogleSignInFunctions.googleSignIn(_auth, context);
                    //     });
                    //   },
                    //   child: Container(
                    //     margin: isWeb
                    //         ? EdgeInsets.fromLTRB(
                    //             MediaQuery.of(context).size.width / 4,
                    //             16,
                    //             MediaQuery.of(context).size.width / 4,
                    //             0)
                    //         : EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(25),
                    //         color: Color(0xff004E98)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Image.asset(
                    //           'images/googleLogo.png',
                    //           height: 40,
                    //         ),
                    //         Container(
                    //           margin: EdgeInsets.fromLTRB(0, 0, 32, 0),
                    //           child: Text(
                    //             'התחבר באמצעות גוגל',
                    //             textAlign:
                    //                 kIsWeb ? TextAlign.start : TextAlign.end,
                    //             style: homePageText(
                    //                 14,
                    //                 Color(0xffFFFFFF).withOpacity(0.9),
                    //                 FontWeight.bold),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Column(
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
                    Container(
                      height: 45,
                      margin: isWeb
                          ? EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 4,
                              16,
                              MediaQuery.of(context).size.width / 4,
                              0)
                          : EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (val) {
                          setState(() {
                            wrongEmail = false;
                          });
                        },
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                            fillColor: Color(0xffFFFFFF),
                            suffixIcon: Icon(Icons.email),
                            filled: true,
                            hintText: 'הזנ/י מייל כאן ',
                            hintStyle: TextStyle(fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                      ),
                    ),
                    Text(
                      (wrongEmail) ? 'שם משתמש לא נכון או לא קיים במערכת' : '',
                      style: TextStyle(
                          decoration: TextDecoration.none, color: Colors.red),
                    ),
                    Container(
                      height: 45,
                      margin: isWeb
                          ? EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 4,
                              16,
                              MediaQuery.of(context).size.width / 4,
                              0)
                          : EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: TextField(
                        controller: passwordController,
                        onChanged: (val) {
                          setState(() {
                            wrongPassword = false;
                          });
                        },
                        textAlign: TextAlign.end,
                        obscureText:
                            (passwordController.text.length > 4) ? true : false,
                        decoration: InputDecoration(
                            fillColor: Color(0xffFFFFFF),
                            suffixIcon: Icon(Icons.remove_red_eye),
                            hintText: 'הזנ/י סיסמא כאן ',
                            hintStyle: TextStyle(fontSize: 14),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                      ),
                    ),
                    Text(
                      (wrongPassword) ? 'סיסמא שגויה' : '',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          decoration: TextDecoration.none, color: Colors.red),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4 + 15,
                        ),
                        Text(
                          'שכחתי סיסמא',
                          // textAlign: TextAlign.end,
                          style: homePageText(
                              12, Colors.lightBlue, FontWeight.normal),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        await _auth
                            .signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text)
                            .catchError((e) {
                          print(e.code);
                          setState(() {
                            switch (e.code) {
                              case 'wrong-password':
                                wrongPassword = true;
                                break;
                              case 'user-not-found':
                                wrongEmail = true;
                                wrongPassword = false;
                                break;
                              case 'invalide-email':
                                wrongEmail = true;
                                wrongPassword = false;
                                break;
                              default:
                                print(e);
                            }
                          });
                        });
                        final userCred = _auth.currentUser;
                        HttpsCallable getRoleById = FirebaseFunctions.instance
                            .httpsCallable('CheckUserRole');
                        var res = await getRoleById.call({'uid': userCred.uid});
                        if (res.data == 'inter') {
                          informationAlertDialog(
                              context, 'אנא התחבר/י לגוגל', '');

                          /// _clientID - the client of the app from google cloud platform
                          var _clientID = new ClientId(
                              Secret.getId(), 'ku6x0zAKIbXvU7X_Kx9nY8_T');

                          print(_clientID);

                          /// _scopes - persmissions for using the user's Calendar
                          const _scopes = const [cal.CalendarApi.CalendarScope];
                          try {
                            await auth
                                .createImplicitBrowserFlow(_clientID, _scopes)
                                .then((auth.BrowserOAuth2Flow flow) {
                              flow
                                  .clientViaUserConsent()
                                  .then((auth.AuthClient client) async {
                                print(
                                    client.credentials.idToken ?? 'No Client');
                                CalendarClient.calendar =
                                    cal.CalendarApi(client);

                                String adminPanelCalendarId = 'primary';

                                var event = CalendarClient.calendar.events;

                                // var events = event.list(adminPanelCalendarId);
                                //
                                // events.then((showEvents) {
                                //   showEvents.items.forEach((cal.Event ev) {
                                //     print(ev.summary);
                                //     print(ev.status);
                                //   });
                                // });

                                /// second sign in for connecting to firebase, silently
                                // var googleUser = await GoogleSignIn()
                                //     .signInSilently()
                                //     .catchError((e) =>
                                //         print('error signing silently' + e));
                                // // await GoogleSignIn(
                                // //         scopes: ['https://www.googleapis.com/auth/userinfo.email'])
                                // //     .signIn();
                                // // Obtain the auth details from the request
                                //
                                // if (googleUser == null) {
                                //   googleUser = await GoogleSignIn().signIn();
                                // }
                                //
                                // final GoogleSignInAuthentication googleAuth =
                                //     await googleUser.authentication;
                                // //
                                // // // Create a new credential
                                // final GoogleAuthCredential credential =
                                //     GoogleAuthProvider.credential(
                                //   accessToken: googleAuth.accessToken,
                                //   idToken: googleAuth.idToken,
                                // );
                                //
                                // /// sign in to firebase authentication
                                // final googleInterSignIn = await _auth
                                //     .signInWithCredential(credential)
                                //     .then((value) {
                                //   print(value.user.email);
                                //   print('successfully linked');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (con) => TabbedPage(
                                              role: res.data,
                                              uid: _auth.currentUser.uid,
                                            )));
                                // }).catchError(
                                //         (e) => print('unable to link ' + e));
                              }).catchError((e) => print(e));
                            });
                          } catch (e) {
                            print('failed connecting to google' + e);
                          }
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (con) => TabbedPage(
                                        role: res.data,
                                        uid: _auth.currentUser.uid,
                                      )));
                        }

                        // await _auth
                        //     .signInWithEmailAndPassword(
                        //         email: emailController.text,
                        //         password: passwordController.text)
                        //     .then((userCred) {
                        //   var getter = FirebaseFirestore.instance
                        //       .collection('users')
                        //       .doc(userCred.user.uid);
                        //   getter.get().then((value) {
                        //     AppUser user = AppUser.fromMap(value.data());
                        //     print(user);

                        //   });
                        // });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        margin: isWeb
                            ? EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width / 4,
                                16,
                                MediaQuery.of(context).size.width / 4,
                                0)
                            : EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blue),
                        child: Text(
                          'להתחברות',
                          style: homePageText(
                              isWeb ? 18 : 12, Colors.white, FontWeight.bold),
                        ),
                      ),
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
