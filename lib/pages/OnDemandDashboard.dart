import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/models/ODMEvent.dart';
import 'package:sign_plus/models/storage.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'package:audioplayers/audio_cache.dart';
import 'dart:js' as js;

class OnDemandDashboard extends StatefulWidget {
  @override
  _OnDemandDashboardState createState() => _OnDemandDashboardState();
}

class _OnDemandDashboardState extends State<OnDemandDashboard> {
  AudioPlayer audioPlayer = AudioPlayer();

  getODMEvents() {
    return FirebaseFirestore.instance
        .collection('on-demand-events')
        .where('answer', isEqualTo: false)
        .snapshots();
  }

  getTimeFromString(String time) {
    return time.substring(12, time.length - 1);
  }

  playSoundWhenChanged(Stream<QuerySnapshot> snapshot) async {
    snapshot.listen((event) {
      event.docChanges.forEach((element) {
        print(element.type);
        if (element.type == DocumentChangeType.added) {
          print('play sound');
          playMusic();
        }
      });
    });
  }

  playMusic() async {
    try {
      await audioPlayer.resume();
    } catch (e) {
      print(e);
    }
  }

  startMusic(String path) async {
    try {
      await audioPlayer.setUrl(
        path,
        isLocal: true,
      );
      await audioPlayer.setReleaseMode(ReleaseMode.STOP);
      await audioPlayer.resume();
      await audioPlayer.pause();
    } catch (e) {
      print(e);
    }
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
      body: InkWell(
        onHover: startMusic('sounds/sound1.mp3'),
        child: Column(
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
                              print(doc['eventID']);
                              var name = await FirebaseConstFunctions
                                  .interBookEventOnDemand
                                  .call({
                                'eventID': doc['eventID'],
                                'interID': FirebaseAuth.instance.currentUser.uid
                              });
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
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
