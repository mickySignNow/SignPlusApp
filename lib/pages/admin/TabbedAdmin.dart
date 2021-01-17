import 'package:flutter/material.dart';
import 'package:sign_plus/pages/admin/AdminPage.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';

class TabbedAdmin extends StatefulWidget {
  int initialIndex;
  TabbedAdmin({@required this.initialIndex});
  @override
  _TabbedAdminState createState() => _TabbedAdminState();
}

class _TabbedAdminState extends State<TabbedAdmin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: widget.initialIndex,
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
            child: new Container(
              padding:
                  new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: AppBar(
                  title: TabBar(
                tabs: <Tab>[
                  Tab(
                    text: 'משתמשים',
                    icon: Icon(
                      Icons.hearing_disabled_sharp,
                    ),
                  ),
                  Tab(text: 'מתורגמנים', icon: Icon(Icons.translate_sharp)),
                  Tab(text: 'ארגונים', icon: Icon(Icons.work)),
                  Tab(
                      text: 'ניהול אירועים',
                      icon: Icon(Icons.event_note_sharp)),
                ],
              )),
            ),
            preferredSize: new Size(MediaQuery.of(context).size.width, 70.0),
          ),
          body: TabBarView(children: [
            AdminPage(
              adminPannel: 'customer',
              functionName: 'CreateCustomer',
            ),
            AdminPage(
              adminPannel: 'interpreter',
              functionName: 'CreateInter',
            ),
            AdminPage(
              adminPannel: 'orginization',
              functionName: 'CreateOrginization',
            ),
            DashboardScreen(uid: null, role: null, query: null, title: null)
          ]),
        ),
      ),
    );
  }
}
