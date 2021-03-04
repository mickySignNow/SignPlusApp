import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/models/ODMEvent.dart';
import 'package:sign_plus/pages/tabbedPage.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class WaitingRoom extends StatefulWidget {
  ODMEvent event;

  WaitingRoom({@required this.event});
  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  bool waiting = true;
  StreamSubscription<QuerySnapshot> listener;
  @override
  void initState() {
    waitingListener();
    Timer timer = Timer.periodic(Duration(minutes: 2), (timer) {
      deleteEvent();
    });
    listener.onError((e) => print(e));

    super.initState();
  }

  waitingListener() {
    try {
      listener = FirebaseFirestore.instance
          .collection('on-demand-events')
          .where('eventID', isEqualTo: widget.event.eventID)
          .snapshots()
          .listen((data) {
        print(data.docs);
        data.docChanges.forEach((element) {
          if (element.type == DocumentChangeType.modified) {
            if (data.docs.first['answer'] == true) {
              setState(() {
                print(element.type);
                waiting = false;
              });
            }
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  deleteEvent() async {
    listener.cancel();
    await FirebaseConstFunctions.deleteODM
        .call({'eventID': widget.event.eventID});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (con) =>
                TabbedPage(uid: widget.event.customerId, role: 'customer')));
  }
  //   setState(() {
  //     print('if ${(event.data()['interID'] != '')}');
  //     if (event.data()['interID'] != '') waiting = false;
  //   });
  // });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print(waiting);
    if (!waiting) {
      print('open link ${widget.event.link}');
      print('open link ${widget.event.customerName}');
      html.window.location.href =
          'https://signowvideo.web.app/?roomName=${widget.event.eventID}' +
              '&name=${widget.event.customerName ?? 'אורח'}';
    }
    // html.window.open(
    //     widget.event.link +
    //         '&name=אורח&exitUrl=https://forms.gle/zq2Rk9ihL1Gdeoxg9',
    //     'video');

    return Scaffold(
      appBar: buildNavBar(context: context, title: 'חדר המתנה'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          waiting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'אנא המתן בזמן שמתורגמנית תתחבר לשיחה',
                      style: TextStyle(
                          fontFamily: 'alef', fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        deleteEvent();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red,
                        ),
                        child: Text(
                          'ביטול וחזרה',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => html.window.location.href =
                          'https://signowvideo.web.app/?roomName=${widget.event.eventID}' +
                              '&name=${widget.event.customerName ?? 'אורח'}',
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        child: Text(
                          'מענה',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(
                      'מתורגמנית מחכה לך בצד השני ',
                      style: TextStyle(
                          fontFamily: 'alef', fontWeight: FontWeight.bold),
                    )
                  ],
                ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              'images/waitingRoom.gif',
              height: (height / 3) * 2 - 15,
              width: width - 40,
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
    ;
  }
}
