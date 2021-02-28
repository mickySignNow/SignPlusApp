import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_plus/pages/LogOutPage.dart';
import 'package:sign_plus/pages/LoginPage.dart';
import 'package:sign_plus/pages/calendar/create_screen.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/GoogleServiceAccount.dart';
import 'package:sign_plus/utils/StaticObjects.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as gapi;
import 'dart:html' as html;

import 'package:vertical_tabs/vertical_tabs.dart';

import 'OnDemandDashboard.dart';

class TabbedPage extends StatefulWidget {
  int initialIndex;
  final String uid;
  final String role;

  TabbedPage({@required this.uid, @required this.role, this.initialIndex});
  @override
  _TabbedPageState createState() => _TabbedPageState();
}

class _TabbedPageState extends State<TabbedPage> {
  var width = 0.0;
  var height = 0.0;
  bool isLoadingNames = true;

  bool interODM = false;

  final _auth = FirebaseAuth.instance;

  isInterODM() async {
    var ODM = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get();
    print(ODM.data());

    interODM = ODM.data()['onDemand'];
  }

  @override
  void initState() {
    GoogleServiceAccount.getClient();
    isInterODM();
    super.initState();

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    print(interODM);
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: widget.initialIndex ?? 0,
        length: (widget.role == 'customer')
            ? 4
            : interODM
                ? 4
                : 3,
        child: Scaffold(
          appBar: PreferredSize(
            child: (width < 720)
                ? Container(
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: AppBar(
                        leading: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                final GoogleSignIn googleSignIn =
                                    new GoogleSignIn();
                                await _auth.signOut();
                                googleSignIn.signOut();

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (con) => LoginPage()));
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  'יציאה',
                                  style: homePageText(
                                      12, Colors.white, FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: TabBar(
                          tabs: (widget.role == 'customer')
                              ? <Tab>[
                                  Tab(
                                    child: Flexible(
                                      child: Text(
                                        'הזמן תור',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    text: '',
                                    icon: Icon(
                                      Icons.add,
                                    ),
                                  ),
                                  Tab(
                                      child: Flexible(
                                        child: Text(
                                          'תורים שנקבעו',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      text: '',
                                      icon: Icon(
                                        Icons.calendar_today,
                                      )),
                                  Tab(
                                      child: Flexible(
                                        child: Text(
                                          'תורים שהוזמנו',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      text: '',
                                      icon: Icon(Icons.calendar_today)),
                                  Tab(
                                      child: Flexible(
                                        child: Text(
                                          'הסטוריה',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      text: '',
                                      icon: Icon(Icons.history))
                                ]
                              : <Tab>[
                                  Tab(
                                      child: Flexible(
                                        child: Text(
                                          'לוח הזמנות',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      text: '',
                                      icon: Icon(Icons.dashboard)),
                                  Tab(
                                      child: Flexible(
                                        child: Text(
                                          'תורים שנקבעו',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      text: '',
                                      icon: Icon(Icons.calendar_today)),
                                  Tab(
                                      child: Flexible(
                                        child: Text(
                                          'הסטוריה',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      text: '',
                                      icon: Icon(Icons.history)),
                                  // interODM
                                  //     ? Tab(
                                  //         child: Flexible(
                                  //           child: Text(
                                  //             'שיחות בזמן אמת',
                                  //             style: TextStyle(fontSize: 10),
                                  //           ),
                                  //         ),
                                  //         text: '',
                                  //         icon: Icon(Icons.timer_sharp))
                                  //     : null,
                                ],
                        )),
                  )
                : Container(
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: AppBar(
                      leading: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              final GoogleSignIn googleSignIn =
                                  new GoogleSignIn();
                              await _auth.signOut();
                              googleSignIn.signOut();

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (con) => LoginPage()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'יציאה',
                                style: homePageText(
                                    12, Colors.white, FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            preferredSize: (width < 720)
                ? Size(MediaQuery.of(context).size.width, 80.0)
                : Size(MediaQuery.of(context).size.width, 0.0),
          ),
          body: (width < 720)
              ? TabBarView(
                  children: (widget.role == 'customer')
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
                              title: 'היסטוריית שיחות'),
                          // interODM ? OnDemandDashboard() : null,
                        ],
                )
              : SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            child:
                                //     SideTabscollapse(
                                //   initialIndex: widget.initialIndex,
                                //   role: widget.role,
                                //   uid: widget.uid,
                                // )

                                VerticalTabs(
                                    initialIndex: widget.initialIndex ?? 0,
                                    direction: TextDirection.rtl,
                                    tabBackgroundColor:
                                        Colors.blue.withOpacity(0.3),
                                    tabTextStyle:
                                        TextStyle(color: Colors.white),
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
                                                icon:
                                                    Icon(Icons.calendar_today)),
                                            Tab(
                                                text: 'תורים שהוזמנו',
                                                icon:
                                                    Icon(Icons.calendar_today)),
                                            Tab(
                                                text: 'היסטוריית שיחות',
                                                icon: Icon(Icons.history)),
                                            Tab(
                                                text: 'יציאה',
                                                icon: Icon(
                                                    Icons.exit_to_app_sharp)),
                                          ]
                                        : <Tab>[
                                            Tab(
                                                text: 'לוח הזמנות',
                                                icon: Icon(Icons.dashboard)),
                                            Tab(
                                                text: 'תורים שנקבעו',
                                                icon:
                                                    Icon(Icons.calendar_today)),
                                            Tab(
                                                text: 'היסטוריית שיחות',
                                                icon: Icon(Icons.history)),
                                            Tab(
                                                text: 'יציאה',
                                                icon: Icon(
                                                    Icons.exit_to_app_sharp)),
                                            // interODM
                                            //     ? Tab(
                                            //         text: 'שיחות בזמן אמת',
                                            //         icon:
                                            //             Icon(Icons.timer_sharp))
                                            //     : null,
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
                                                title: 'היסטוריית שיחות'),
                                            LogOutPage(auth: _auth),
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
                                                title: 'היסטוריית שיחות'),
                                            LogOutPage(auth: _auth),
                                            // interODM
                                            //     ? OnDemandDashboard()
                                            //     : null,
                                          ])),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
/*

 */
