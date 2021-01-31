import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sign_plus/utils/GoogleServiceAccount.dart';

import 'package:sign_plus/utils/style.dart';

import '../utils/style.dart';

class VideoCallPhone extends StatefulWidget {
  VideoCallPhone({Key key}) : super(key: key);

  @override
  _VideoCallPhoneState createState() => _VideoCallPhoneState();
}

class _VideoCallPhoneState extends State<VideoCallPhone> {
  bool waiting;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GoogleServiceAccount.getClient();
    return Scaffold(
      appBar: buildNavBar(context: context, title: ''),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Container(child: Text('new page'))],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
