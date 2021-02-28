import 'package:flutter/material.dart';
import 'package:sign_plus/pages/admin/AdminEventsDashboard.dart';
import 'package:sign_plus/pages/admin/CustomerAdminDashboard.dart';
import 'package:sign_plus/pages/admin/AdminPage.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';

import 'InterAdminDashboard.dart';
import 'OrginizationAdminDashboard.dart';

class TabbedEventsAdmin extends StatefulWidget {
  int initialIndex;
  TabbedEventsAdmin({@required this.initialIndex});
  @override
  _TabbedEventsAdminState createState() => _TabbedEventsAdminState();
}

class _TabbedEventsAdminState extends State<TabbedEventsAdmin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: widget.initialIndex,
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
            child: new Container(
              padding:
                  new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: AppBar(
                  title: TabBar(
                tabs: <Tab>[
                  Tab(
                    text: 'עכשיו',
                    icon: Icon(
                      Icons.timer_sharp,
                    ),
                  ),
                  Tab(text: 'נקבעו', icon: Icon(Icons.calendar_today_sharp)),
                  Tab(text: 'הוזמנו', icon: Icon(Icons.pending_sharp)),
                  Tab(text: 'הסטוריה', icon: Icon(Icons.history)),
                  Tab(text: 'חיפוש', icon: Icon(Icons.search)),
                ],
              )),
            ),
            preferredSize: new Size(MediaQuery.of(context).size.width, 70.0),
          ),
          body: TabBarView(children: [
            AdminEventsDashboard(query: 'booked'),
            AdminEventsDashboard(query: 'booked'),
            AdminEventsDashboard(query: 'requsets'),
            AdminEventsDashboard(query: 'history'),
            AdminEventsDashboard(query: 'booked'),
          ]),
        ),
      ),
    );
  }
}
