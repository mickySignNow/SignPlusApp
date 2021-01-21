import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

/// class for events to firebase and read from firebase
class EventInfo {
  final String id;
  final String customerId;
  final String interId;
  final String title;
  final String description;
  final String link;
  String state;
  bool answer;
  DateTime creationTime;
  // final List<dynamic> attendeeEmails;
  final String email;
  final String customerName;
  final String interName;

  final int startTimeInEpoch;
  final int endTimeInEpoch;
  final double length;
  final String date;
  bool occupied = false;

  /// constructor will require what parameters must EventInfo class have in each instance
  EventInfo({
    @required this.occupied,
    @required this.id,
    @required this.title,
    @required this.description,
    this.link,
    this.customerName,
    this.interName,
    @required this.email,
    @required this.startTimeInEpoch,
    @required this.endTimeInEpoch,
    @required this.length,
    @required this.date,
    @required this.state,
    @required this.answer,
    @required this.creationTime,
    @required this.interId,
    @required this.customerId,
  });

  /// create instance of EventInfo and fill from a Map/dictionary
  EventInfo.fromMap(Map snapshot)
      : id = snapshot['id'] ?? '',
        description = snapshot['desc'],
        title = snapshot['title'],
        link = snapshot['link'],
        email = snapshot['emails'] ?? '',
        // shouldNotifyAttendees = snapshot['should_notify'],
        // hasConfereningSupport = snapshot['has_conferencing'],
        startTimeInEpoch = snapshot['start'],
        customerName = snapshot['customerName'],
        interName = snapshot['interName'],
        endTimeInEpoch = snapshot['end'],
        length = snapshot['length'],
        date = snapshot['date'],
        customerId = snapshot['customerID'],
        interId = snapshot['interID'],
        state = snapshot['state'],
        answer = snapshot['answer'],
        creationTime = snapshot['creationTime'],
        occupied = snapshot['occupied'];

  /// convert EventInfo to Json
  toJson() {
    return {
      'id': id,
      'customerID': customerId,
      'interID': interId,
      'state': state,
      'answer': answer,
      'title': title,
      'desc': description,
      // 'loc': location,
      'link': link,
      'emails': email,
      'customerName': customerName,
      'interName': interName,
      // 'should_notify': shouldNotifyAttendees,
      // 'has_conferencing': hasConfereningSupport,
      'start': startTimeInEpoch,
      'end': endTimeInEpoch,
      'length': length,
      'date': date,
      'occupied': occupied,
    };
  }
}
