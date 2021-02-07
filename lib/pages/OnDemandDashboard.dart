import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/models/ODMEvent.dart';
import 'package:sign_plus/models/storage.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class OnDemandDashboard extends StatefulWidget {
  @override
  _OnDemandDashboardState createState() => _OnDemandDashboardState();
}

class _OnDemandDashboardState extends State<OnDemandDashboard> {
  getODMEvents() {
    return FirebaseFirestore.instance
        .collection('ODM')
        .where('interID', isEqualTo: '')
        .where('state', isEqualTo: 'pending')
        .snapshots();
  }

  getTimeFromString(String time) {
    return time.substring(12, time.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: buildNavBar(context: context, title: 'ON DEMAND - און דמנד'),
      body: Column(
        children: [
          Row(
            children: [
              RaisedButton(
                child: Text('להתנתקות'),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, 'LoginPage');
                },
              )
            ],
          ),
          Flexible(
            child: StreamBuilder(
              stream: getODMEvents(),
              builder: (context, snapshot) {
                print('Stream $snapshot');
                if (snapshot.hasData) {
                  return ListView(
                      children: snapshot.data.docs.map((doc) {
                    ODMEvent event = ODMEvent.fromMap(doc);
                    print(doc);
                    print(event.title);
                    print(event.customerName);
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.call_sharp),
                        title: Text(event.title),
                        subtitle: Column(
                          children: [
                            Text(event.customerName),
                            SizedBox(
                              height: 5,
                            ),
                            Text(DateFormat('hh:mm')
                                .format(DateTime.parse(doc['orderTime']))),
                          ],
                        ),
                        trailing: RaisedButton(
                          child: Text('מענה'),
                          onPressed: () async {
                            event.catchEvent(
                                FirebaseAuth.instance.currentUser.uid);
                            var name = await FirebaseConstFunctions.getInterName
                                .call({"interID": event.interId});
                            html.window.location.href = event.link +
                                '&name=${name.data}&exitUrl=https://forms.gle/ZUNRJWgkvCckxaoR6';
                          },
                        ),
                      ),
                    );
                  }).toList());
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
