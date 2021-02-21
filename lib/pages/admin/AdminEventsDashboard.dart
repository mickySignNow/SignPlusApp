import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:googleapis/accessapproval/v1.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:googleapis/calendar/v3.dart' as CalendarApi;
import 'package:googleapis/websecurityscanner/v1.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/models/event_info.dart';
import 'package:sign_plus/pages/calendar/create_screen.dart';
import 'package:sign_plus/pages/calendar/edit_screen.dart';
import 'package:sign_plus/resources/color.dart';
import 'package:sign_plus/models/storage.dart' as db;
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/StaticObjects.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminEventsDashboard extends StatefulWidget {
  final String query;
  AdminEventsDashboard({
    @required this.query,
  });
  @override
  _AdminEventsDashboardState createState() => _AdminEventsDashboardState();
}

class _AdminEventsDashboardState extends State<AdminEventsDashboard> {
  db.Storage storage = db.Storage();
  bool isLinkPressed = false;
  var listKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  final functions = FirebaseFunctions.instance;

  BuildContext dialogContext;

  dashboardQuery(String query) async {
    print(query);
    var list;

    switch (query) {
      case 'booked':
        list = await FirebaseConstFunctions.getAllOccupiedEvents.call({'': ''});
        break;
      case 'history':
        list = await FirebaseConstFunctions.gethistoryEvents.call({'': ''});
        break;
      case 'requests':
        list =
            await FirebaseConstFunctions.getAllUnOccupiedEvents.call({'': ""});
        break;
    }
    print(list.data);
    return list.data;
  }

  combineLists(Map<dynamic, dynamic> list, Map<dynamic, dynamic> name) {
    return {'list': list, 'name': name};
  }

  @override
  Widget build(BuildContext context) {
    CalendarClient calendar = CalendarClient();
    final width = MediaQuery.of(context).size.width;
    bool isWeb = (width > 700);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: buildNavBar(context: context, title: '', role: ''),
      // AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   iconTheme: IconThemeData(
      //     color: Colors.grey, //change your color here
      //   ),
      //   title: Text(
      //     'Event Details',
      //     style: TextStyle(
      //       color: CustomColor.dark_blue,
      //       fontSize: 22,
      //     ),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: CustomColor.dark_cyan,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => CreateScreen(),
      //       ),
      //     );
      //   },
      // ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          color: Colors.white.withOpacity(0.9),
          child: FutureBuilder(
            future: dashboardQuery(widget.query),
            builder: (context, snapshot) {
              print(snapshot.data);
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var event = EventInfo.fromMap(snapshot.data[index]);
                  print(event.toJson());
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                FlatButton(
                                  child: Text('שנה פרטים'),
                                  onPressed: () {
                                    /// change event details
                                  },
                                ),
                                FlatButton(
                                  child: Text('מחק'),
                                  onPressed: () {
                                    /// delete events
                                  },
                                ),
                                FlatButton(
                                  child: Text('שייך'),
                                  onPressed: () {
                                    /// assign essign event to inter by mail
                                  },
                                ),
                                FlatButton(
                                  child: Text('בטל'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              margin: isWeb
                                  ? EdgeInsets.only(
                                      left:
                                          MediaQuery.of(context).size.width / 4,
                                      right: 10)
                                  : EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                              padding: EdgeInsets.only(
                                bottom: 16.0,
                                top: 16.0,
                                left: 16.0,
                                right: 16.0,
                              ),
                              color: Colors.white,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 10,
                                        blurRadius: 10)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  (event.occupied)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              event.title,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                // letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Text(
                                                'ממתין לאישור מתורגמן',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  // letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Text(
                                                event.title,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  // letterSpacing: 1,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                  SizedBox(height: 10),
                                  Text(event.customerName),
                                  Text(
                                    event.description ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Text(
                                  //   StaticObjects.nameAndId[event.id],
                                  //   style: TextStyle(color: Colors.red),
                                  // ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (event.link != null) {
                                            launch(event.link +
                                                '&name=invisibleAdmin');
                                            isLinkPressed = true;
                                          }
                                        });
                                      },
                                      child: Text(
                                        event.link ?? '',
                                        style: TextStyle(
                                          color: CustomColor.dark_blue
                                              .withOpacity(0.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 5,
                                        color: (event.occupied)
                                            ? CustomColor.neon_green
                                            : Colors.red,
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('dd/MM/yy').format(
                                                DateTime.parse(event.date)),
                                            style: TextStyle(
                                              color: CustomColor.dark_cyan,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          Text(
                                            '${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(event.startTimeInEpoch))}',
                                            style: TextStyle(
                                              color: CustomColor.dark_cyan,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          Text(
                                            ' למשך ${event.length} דקות ',
                                            style: TextStyle(
                                              color: CustomColor.dark_cyan,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 1.5,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
