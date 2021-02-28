import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/pages/NotificationPage.dart';
import 'package:sign_plus/pages/admin/AdminPage.dart';
import 'package:sign_plus/pages/LoginPage.dart';
import 'package:sign_plus/pages/admin/TabbedAdmin.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';
import 'package:sign_plus/pages/tabbedPage.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/NavigationRoutes.dart';
import 'package:sign_plus/utils/StaticObjects.dart';
import 'package:sign_plus/utils/secrets.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:googleapis_auth/auth_browser.dart' as auth;
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

void prompt(String url) {}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextDirection rtl = TextDirection.rtl;
    return MaterialApp(
      routes: {
        'LoginPage': (context) => LoginPage(),
        'Admin': (context) => TabbedAdmin(
              initialIndex: 0,
            ),
        'adminPage': (context) =>
            AdminPage(adminPannel: null, functionName: null)
      },
      title: 'Sign+',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
          child: Directionality(
              textDirection: TextDirection.ltr, child: MyHomePage())),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('he'), // Spanish
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  router() async {
    final user = _auth.currentUser;
    if (user != null) {
      print(user.uid);

      /// getRoleById

      var res =
          await FirebaseConstFunctions.getRoleById.call({'uid': user.uid});

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (con) => TabbedPage(uid: user.uid, role: res.data)));
    } else {
      Navigator.of(context).pushNamed('LoginPage');
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         settings: NavigationRoutes.login, builder: (con) => LoginPage()));
    }
  }

  @override
  initState() {
    ///shows main screen for 2 sec and then pushes login screen
    // Timer timer = Timer(Duration(seconds: 2), (() async {
    //   setState(() {
    //     router();
    //   });
    // }));
    Navigator.push(context,
        MaterialPageRoute(builder: (con) => TabbedAdmin(initialIndex: 0)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildNavBar(context: context, title: ''),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xff9AB7D0),
            Color(0xff004E98),
            Color(0xff0F122A)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                child: Image.asset(
                  'images/sign+_white.png',
                  // fit: BoxFit.fill,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                      child: Text(
                    'Sign+',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 27),
                  )),
                  Center(
                    child: Text(
                      'נותנים לך יד',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontSize: 24),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
