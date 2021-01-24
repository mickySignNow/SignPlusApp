// import 'dart:developer';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_plus/pages/videoCallPhone.dart';
// import 'package:sign_plus/pages/videoCallWeb.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_plus/url_launcher/mobile.dart';
// import 'package:sign_plus/utils/style.dart';
// import 'package:googleapis_auth/auth_io.dart' as gapi;
//
// import 'package:googleapis/calendar/v3.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/src/material/colors.dart' as Colors;
//
// class CallAnswer extends StatefulWidget {
//   final String userKind;
//   CallAnswer({@required this.userKind});
//
//   @override
//   _CallAnswerState createState() => _CallAnswerState();
// }
//
// class _CallAnswerState extends State<CallAnswer> {
//   final _auth = FirebaseAuth.instance;
//
//   // static const _scopes = const [CalendarApi.CalendarScope];
//   //
//   // var _clientID = gapi.ClientId(
//   //     "144761639029-5s73a25oe2ug4v112h57jmb8120sb2uh.apps.googleusercontent.com",
//   //     "");
//   //
//   // Event createEvent() {
//   //   Event event = Event(); // Create object of event
//   //   event.summary = 'new event'; //Setting summary of object
//   //
//   //   EventDateTime start = new EventDateTime(); //Setting start time
//   //   start.dateTime = DateTime(2020, 11, 18, 15);
//   //   print(start.dateTime);
//   //   start.timeZone = "GMT+05:00";
//   //   event.start = start;
//   //
//   //   EventDateTime end = new EventDateTime(); //setting end time
//   //   end.timeZone = "GMT+05:00";
//   //   end.dateTime = DateTime(2020, 11, 18, 16);
//   //   event.end = end;
//   //
//   //   print(event.status);
//   //
//   //   return event;
//   // }
//   //
//   // instertingEvent(Event event) {
//   //   try {
//   //     gapi
//   //         .clientViaUserConsent(_clientID, _scopes, prompt)
//   //         .then((gapi.AuthClient client) {
//   //       var calendar = CalendarApi(client);
//   //       String calendarId = "mickykro@gmail.com";
//   //       print(calendar.events.instances(calendarId, event.id));
//   //       if (calendar != null) {
//   //         calendar.events.insert(event, calendarId).then((value) {
//   //           print("ADDEDDD_________________${value.status}");
//   //           if (value.status == "confirmed") {
//   //             log('Event added in google calendar');
//   //           } else {
//   //             log("Unable to add event in google calendar");
//   //           }
//   //         });
//   //       }
//   //     });
//   //   } catch (e) {
//   //     log('Error creating event $e');
//   //   }
//   // }
//   //
//   // void prompt(String url) async {
//   //   launch(
//   //       'https://www.googleapis.com/calendar/v3/calendars/mickykro@gmail.com/events?key=AIzaSyAzXEKHXajEse8TXQRirRohqC7oE4AUEYM');
//   //
//   //   // if (await canLaunch(url)) {
//   //   //   await launch(url);
//   //   // } else {
//   //   //   throw 'Could not launch $url';
//   //   // }
//   // }
//
//   // as the name: the method checks if platfrom in use is web
//   isWeb() {
//     if (kIsWeb) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => VideoCallWeb()));
//     } else {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => VideoCallPhone()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildNavBar(context: context,
//       title: ''),
//       body: SafeArea(
//         child: Container(
//           color: Color(0xffFAFAFA).withOpacity(0.8),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 (widget.userKind == 'deaf')
//                     ? Column(
//                         children: [
//                           Text(
//                             'זקוקים למתורגמנים',
//                             style: homePageText(
//                                 24, Color(0xff191919), FontWeight.bold),
//                           ),
//                           Text('שיתנו לכם יד?',
//                               style: homePageText(
//                                   24, Color(0xff191919), FontWeight.bold)),
//                         ],
//                       )
//                     : Text('הגש עזרה'),
//
//                 InkWell(
//                   onTap: () {
//                     isWeb();
//                   },
//                   child:
//                       Container(child: Image.asset('images/sign-language.png')),
//                 ),
//                 // InkWell(
//                 //   child: Center(
//                 //     child: Container(
//                 //       height: 40,
//                 //       width: MediaQuery.of(context).size.width * 0.7,
//                 //       decoration: BoxDecoration(
//                 //         color: Colors.Colors.blue,
//                 //         borderRadius: BorderRadius.circular(20),
//                 //       ),
//                 //       child: Text(
//                 //         'connect to google',
//                 //         textAlign: TextAlign.center,
//                 //         style: TextStyle(decoration: TextDecoration.none),
//                 //       ),
//                 //     ),
//                 //   ),
//                 //   onTap: () async {
//                 //     // googleSignIn(_auth);
//                 //   },
//                 // ),
//                 // RaisedButton(
//                 //   onPressed: () {
//                 //     // instertingEvent(createEvent());
//                 //   },
//                 //   child: Text('book an event'),
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
