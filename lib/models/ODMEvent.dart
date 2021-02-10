import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// class for events to firebase and read from firebase
class ODMEvent {
  static final NOW = DateTime.now();
  final String interId;
  final String title;
  final String link;
  bool isAnswered;
  String status;
  final String customerName;
  final String interName;
  final start;

  DateTime requestTime;

  // final double length;
  // final String date;
  // bool occupied = false;

  /// constructor will require what parameters must EventInfo class have in each instance
  ODMEvent({
    this.start,
    this.requestTime,
    @required this.title,
    this.isAnswered,
    // @required this.description,
    @required this.link,
    // @required this.email,
    @required this.customerName,
    this.interName,
    // @required this.length,
    // @required this.date,
    this.status,
    // @required this.answer,
    this.interId,
    // @required this.customerId,
  });

  /// create instance of EventInfo and fill from a Map/dictionary
  ODMEvent.fromMap(Map snapshot)
      : title = snapshot['title'],
        link = snapshot['link'],
        customerName = snapshot['customerName'],
        requestTime =
            DateTime.fromMillisecondsSinceEpoch(snapshot['requestTime']),
        interName = snapshot['interName'],
        interId = snapshot['interID'],
        isAnswered = snapshot['isAnswered'],
        start = snapshot['start'],
        status = snapshot['status'];

  /// convert EventInfo to Json
  toJson() {
    return {
      'title': title,
      'link': link,
      'customerName': customerName,
    };
  }

  // catchEvent(
  //   String interId,
  // ) {
  //   FirebaseFirestore.instance.collection('ODM').doc(id).update({
  //     'interID': interId,
  //     'state': ' online',
  //   });
  // }
}
