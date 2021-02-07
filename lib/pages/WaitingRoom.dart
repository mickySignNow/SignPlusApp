import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/models/ODMEvent.dart';
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
  @override
  void initState() {
    waitingListener();
    print(widget.event.orderTime);

    super.initState();
  }

  waitingListener() {
    FirebaseFirestore.instance
        .collection('ODM')
        .where('id', isEqualTo: widget.event.id)
        .snapshots()
        .listen((data) {
      print(data);
      print(data.docs.first['state']);
      data.docChanges.forEach((element) {
        setState(() {
          print(element.type);
          if (element.type == DocumentChangeType.modified) waiting = false;
        });
      });
    });
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
    if (!waiting)
      html.window.location.href = widget.event.link +
          '&name=${widget.event.customerName ?? 'אורח'}&exitUrl=https://forms.gle/zq2Rk9ihL1Gdeoxg9';
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
              ? Text(
                  'אנא המתן בזמן שמתורגמנית תתחבר לשיחה',
                  style: TextStyle(
                      fontFamily: 'alef', fontWeight: FontWeight.bold),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => launch(widget.event.link +
                          '&name=אורח&exitUrl=https://forms.gle/zq2Rk9ihL1Gdeoxg9'),
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
