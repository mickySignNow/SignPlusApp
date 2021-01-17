import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:googleapis/accessapproval/v1.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:googleapis/calendar/v3.dart' as CalendarApi;
import 'package:intl/intl.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/models/event_info.dart';
import 'package:sign_plus/pages/calendar/create_screen.dart';
import 'package:sign_plus/pages/calendar/edit_screen.dart';
import 'package:sign_plus/resources/color.dart';
import 'package:sign_plus/models/storage.dart' as db;
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  final String uid;
  final String role;
  final String query;
  final String title;
  DashboardScreen(
      {@required this.uid,
      @required this.role,
      @required this.query,
      @required this.title});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  db.Storage storage = db.Storage();
  bool isLinkPressed = false;
  var listKey = GlobalKey();

  final functions = FirebaseFunctions.instance;

  var customerName = '';

  BuildContext dialogContext;

  getAllEventsAdmin() async {
    var list;
    HttpsCallable getAllEvents = functions.httpsCallable('GetAllEvents');
    var data = {'': ''};
    list = await getAllEvents
        .call(data)
        .whenComplete(() => print('got all events'))
        .catchError((e) => print(e));
    print(list);

    return list.data;
  }

  dashboardQuery(String query, String role) {
    print(query);
    var list;
    if (widget.uid == null) {
      print('admin');
      HttpsCallable getAllEvents = functions.httpsCallable('GetAllEvents');
      var data = {'': ''};
      list = getAllEvents
          .call(data)
          .whenComplete(() => print('got all events'))
          .catchError((e) => print(e));
      print('list ${list.data}');
      return list.data;
    } else {
      if (role == 'customer') {
        switch (query) {
          case 'booked':
            return storage.retrieveOccupiedEvents(widget.uid, false);
          case 'history':
            return storage.retrieveCustomerhistoryEvents(widget.uid);
          case 'pending':
            return storage.retrieveRequestEvents(widget.uid);
        }
      } else {
        switch (query) {
          case 'booked':
            print("widget.uid  " + widget.uid);
            return storage.retrieveOccupiedEvents(widget.uid, true);
          case 'history':
            return storage.retrieveInterhistoryEvents(widget.uid);
          case 'requests':
            return storage.retrieveAllEvents();
        }
      }
    }
  }

  getCustomerName(String id) async {
    bool complete = false;
    HttpsCallable getName = functions.httpsCallable('GetCustomerNameById');
    var name = await getName.call({'customerID': id});
    return name.data;
  }

  @override
  Widget build(BuildContext context) {
    CalendarClient calendar = CalendarClient();
    final width = MediaQuery.of(context).size.width;
    bool isWeb = (width > 700);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: buildNavBar(context: context, title: widget.title, role: ''),
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
          child: (widget.uid != null)
              ? StreamBuilder(
                  stream: dashboardQuery(widget.query, widget.role),
                  builder: (context, snapshot) {
                    print(' snapshot  ${snapshot.data}');
                    if (snapshot.hasData) {
                      if (snapshot.data.documents.length > 0) {
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> eventInfo =
                                  snapshot.data.documents[index].data();
                              print(eventInfo);

                              /// Event Info is class in components package go to class
                              EventInfo event = EventInfo.fromMap(eventInfo);

                              print('event print $eventInfo');

                              DateTime startTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      event.startTimeInEpoch);

                              String startTimeString =
                                  DateFormat('HH:mm').format(startTime);
                              String dateString =
                                  DateFormat('dd/MM/yy').format(startTime);

                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  margin: isWeb
                                      ? EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          right: 10,
                                          top: 10)
                                      : EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                  child: InkWell(
                                    onTap: (widget.role == 'user')
                                        ? () {
                                            /// Todo: edit or dialog for users event
                                          }
                                        : () {
                                            /// Todo: authenticate to google

                                            if (widget.role == 'inter' &&
                                                event.occupied == false) {
                                              print(event.interId);
                                              print(event.occupied);

                                              ConfirmAlertBox(
                                                buttonTextForYes: 'כן',
                                                buttonColorForYes: Colors.blue,
                                                buttonTextColorForYes:
                                                    Colors.white,
                                                buttonTextForNo: 'לא',
                                                buttonColorForNo:
                                                    Colors.transparent,
                                                buttonTextColorForNo:
                                                    Colors.blue,
                                                onPressedYes: () async {
                                                  List<
                                                          CalendarApi
                                                              .EventAttendee>
                                                      attendeeEmails = [];
                                                  CalendarApi.EventAttendee
                                                      eventAttendee =
                                                      CalendarApi
                                                          .EventAttendee();

                                                  eventAttendee.email =
                                                      eventInfo['emails'];

                                                  attendeeEmails
                                                      .add(eventAttendee);
                                                  print(eventInfo);

                                                  calendar
                                                      .insert(
                                                          title: eventInfo[
                                                              'title'],
                                                          attendeeEmailList:
                                                              attendeeEmails,
                                                          shouldNotifyAttendees:
                                                              true,
                                                          hasConferenceSupport:
                                                              true,
                                                          startTime: DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  eventInfo[
                                                                      'start']),
                                                          endTime: DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  eventInfo[
                                                                      'end']))
                                                      .catchError((e) => print(
                                                          e + " faild inserting"))
                                                      .then((eventData) {
                                                    print(eventData['id']);
                                                    print(eventData);
                                                    setState(() {
                                                      EventInfo eventInfoClass =
                                                          EventInfo.fromMap(
                                                              eventInfo);
                                                      print(eventInfoClass);
                                                      storage
                                                          .catchEvent(
                                                              eventInfoClass,
                                                              widget.uid,
                                                              eventData['link'])
                                                          .whenComplete(() => print(
                                                              'event was caught'));
                                                    });
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();

                                                    /// Todo: upload event to storage
                                                  }).catchError((e) {
                                                    print(e);
                                                  });
                                                },
                                                context: context,
                                                title: 'קביעת תור',
                                                infoMessage: catchDialogText(
                                                    DateFormat('yyyy/MM/dd')
                                                        .format(DateTime.parse(
                                                            event.date)),
                                                    DateFormat('HH:mm').format(
                                                        DateTime.fromMillisecondsSinceEpoch(
                                                                event
                                                                    .startTimeInEpoch)
                                                            .toLocal()),
                                                    event.length.toString()),
                                                icon: CupertinoIcons.check_mark,
                                              );
                                            }
                                          },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// Flexible
                                        Flexible(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 16.0,
                                              left: 16.0,
                                              right: 16.0,
                                            ),
                                            color: Colors.white,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: 10,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 4)),
                                                ]),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                (eventInfo['occupied'])
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            event.title,
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                              fontSize: 22,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              // letterSpacing: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            flex: 1,
                                                            child: Text(
                                                              'ממתין לאישור מתורגמן',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                // letterSpacing: 1,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: Text(
                                                              event.title,
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                // letterSpacing: 1,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                SizedBox(height: 10),
                                                Text(event.email),
                                                Text(
                                                  event.description ?? '',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          bottom: 8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (event.link != null) {
                                                        var name = 'signow';
                                                        if (widget.role ==
                                                            'customer') {
                                                          final getname =
                                                              await FirebaseFunctions
                                                                  .instance
                                                                  .httpsCallable(
                                                                      "GetCustomerNameById")
                                                                  .call({
                                                            "customerID":
                                                                event.interId
                                                          });
                                                          name = getname.data;
                                                        } else {
                                                          final getname =
                                                              await FirebaseFunctions
                                                                  .instance
                                                                  .httpsCallable(
                                                                      "GetInterNameById")
                                                                  .call({
                                                            "interID":
                                                                event.interId
                                                          });
                                                          name = getname.data;
                                                        }
                                                        launch(event.link +
                                                            '&name=$name');
                                                        isLinkPressed = true;
                                                      }
                                                    },
                                                    child: Text(
                                                      event.link ?? '',
                                                      style: TextStyle(
                                                        color: CustomColor
                                                            .dark_blue
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                          ? CustomColor
                                                              .neon_green
                                                          : Colors.red,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dateString,
                                                          style: TextStyle(
                                                            color: CustomColor
                                                                .dark_cyan,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            letterSpacing: 1.5,
                                                          ),
                                                        ),
                                                        Text(
                                                          '$startTimeString',
                                                          style: TextStyle(
                                                            color: CustomColor
                                                                .dark_cyan,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            letterSpacing: 1.5,
                                                          ),
                                                        ),
                                                        Text(
                                                          ' למשך ${event.length} דקות ',
                                                          style: TextStyle(
                                                            color: CustomColor
                                                                .dark_cyan,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Text(
                            'No Events',
                            style: TextStyle(
                              color: Colors.black38,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(CustomColor.sea_blue),
                      ),
                    );
                  },
                )
              : FutureBuilder(
                  future: getAllEventsAdmin(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var event = EventInfo.fromMap(snapshot.data[index]);
                        print(event);
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
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22,
                                                      // letterSpacing: 1,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    child: Text(
                                                      'ממתין לאישור מתורגמן',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        // letterSpacing: 1,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                        SizedBox(height: 10),
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
                                        Text(customerName),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (event.link != null) {
                                                  launch(event.link);
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
                                                      DateTime.parse(
                                                          event.date)),
                                                  style: TextStyle(
                                                    color:
                                                        CustomColor.dark_cyan,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    letterSpacing: 1.5,
                                                  ),
                                                ),
                                                Text(
                                                  '${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(event.startTimeInEpoch))}',
                                                  style: TextStyle(
                                                    color:
                                                        CustomColor.dark_cyan,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    letterSpacing: 1.5,
                                                  ),
                                                ),
                                                Text(
                                                  ' למשך ${event.length} דקות ',
                                                  style: TextStyle(
                                                    color:
                                                        CustomColor.dark_cyan,
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
