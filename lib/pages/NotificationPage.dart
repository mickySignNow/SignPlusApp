import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _token;
  FirebaseMessaging messaging = FirebaseMessaging();

  getFcmToken() async {
    _token = await getToken();
  }

  Future requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging();

    final settings = await messaging.requestNotificationPermissions();

    return settings;
  }

  Future<String> getToken([bool force = false]) async {
    if (force || _token == null) {
      await requestPermission().then((value) => print(value));
      _token = await messaging.getToken();
    }

    return _token;
  }

  @override
  void initState() {
    getToken(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(),
    );
  }
}
