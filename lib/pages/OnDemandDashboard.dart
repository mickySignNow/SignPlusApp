import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/models/ODMEvent.dart';
import 'package:sign_plus/models/storage.dart';
import 'package:sign_plus/utils/AlertAudioPlayer.dart';
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
    final snapShot = FirebaseFirestore.instance
        .collection('on-demand-events')
        .where('state', isEqualTo: 'pending')
        .snapshots();
    return snapShot;
  }

  getTimeFromString(String time) {
    return time.substring(12, time.length - 1);
  }

  playSoundWhenChanged(Stream<QuerySnapshot> snapshot) async {
    snapshot.listen((event) {
      event.docChanges.forEach((element) {
        print(element.type);
        if (element.type == DocumentChangeType.added) {
          startMusic();
        }
      });
    });
  }

  @override
  void initState() {
    playSoundWhenChanged(getODMEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: StreamBuilder(
              stream: getODMEvents(),
              builder: (context, snapshot) {
                print('Stream ${snapshot.hasData}');
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return ListView(
                      children: snapshot.data.docs.map((doc) {
                    print('doc $doc');
                    print(doc['title']);
                    print(doc['customerName']);
                    print(doc['requestTime']);
                    // ODMEvent event = ODMEvent.fromMap(doc);
                    // print(event.toJson());
                    final title = doc['title'];
                    final name = doc['customerName'];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.call_sharp),
                        title: Text(title),
                        subtitle: Column(
                          children: [
                            Text(name),
                            SizedBox(
                              height: 5,
                            ),
                            Text(DateFormat('HH:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                        doc['requestTime'])
                                    .toLocal())),
                          ],
                        ),
                        trailing: RaisedButton(
                          child: Text('מענה'),
                          onPressed: () async {
                            var name = await FirebaseConstFunctions
                                .interBookEventOnDemand
                                .call({'link': doc['link']});
                            html.window.location.href =
                                doc['link'] + '&name=${name.data}';
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
