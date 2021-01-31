import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// class for events to firebase and read from firebase
class ODMEvent {
  static final NOW = DateTime.now();
  final String id;
  // final String customerId;
  final String interId;
  final String title;
  // final String description;
  final String link;
  String state;
  // bool answer;
  // final List<dynamic> attendeeEmails;
  // final String email;
  final String customerName;
  final String interName = 'מתורגמנית';

  DateTime orderTime = DateTime(NOW.year, NOW.month, NOW.day,
      TimeOfDay.now().hour, TimeOfDay.now().minute);

  // final double length;
  // final String date;
  // bool occupied = false;

  /// constructor will require what parameters must EventInfo class have in each instance
  ODMEvent({
    // @required this.occupied,
    @required this.id,
    @required this.title,
    // @required this.description,
    this.link,
    // @required this.email,
    this.customerName,
    // @required this.length,
    // @required this.date,
    @required this.state,
    // @required this.answer,
    @required this.interId,
    // @required this.customerId,
  });

  /// create instance of EventInfo and fill from a Map/dictionary
  ODMEvent.fromMap(Map snapshot)
      : id = snapshot['id'] ?? '',
        // description = snapshot['desc'],
        title = snapshot['title'],
        link = snapshot['link'],
        // email = snapshot['emails'] ?? '',
        // shouldNotifyAttendees = snapshot['should_notify'],
        // hasConfereningSupport = snapshot['has_conferencing'],
        // length = snapshot['length'],
        // date = snapshot['date'],
        // customerId = snapshot['customerID'],
        customerName = snapshot['customerName'],
        orderTime = DateTime.parse(snapshot['orderTime']),
        interId = snapshot['interID'],
        state = snapshot['state'];
  // answer = snapshot['answer'],
  // occupied = snapshot['occupied']

  /// convert EventInfo to Json
  toJson() {
    print(id);
    print(interId);
    print(state);
    print(link);
    print(interName);
    print(orderTime);
    return {
      'id': id,
      // 'customerID': customerId,
      'interID': interId,
      'state': state,
      // 'answer': answer,
      'title': title,
      // 'desc': description,
      // 'loc': location,
      'link': link,
      // 'emails': email,
      'customerName': customerName,
      'interName': interName,
      // 'should_notify': shouldNotifyAttendees,
      // 'has_conferencing': hasConfereningSupport,
      'orderTime': orderTime.toString(),
      // 'length': length,
      // 'date': date,
      // 'occupied': occupied,
    };
  }

  createODMEvent() {
    FirebaseFirestore.instance.collection('ODM').doc(id).set(this.toJson());
  }

  catchEvent(
    String interId,
  ) {
    FirebaseFirestore.instance.collection('ODM').doc(id).update({
      'interID': interId,
      'state': ' online',
    });
  }
}
