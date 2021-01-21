import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/models/event_info.dart';

final CollectionReference mainCollection =
    FirebaseFirestore.instance.collection('events');
// final CollectionReference allevents =
//     FirebaseFirestore.instance.collection('all Events');

class Storage {
  Future<void> storeEventData(EventInfo eventInfo, String uid) async {
    DocumentReference documentReferencer = mainCollection.doc(eventInfo.id);
    Map<String, dynamic> data = eventInfo.toJson();

    await documentReferencer.set(data).whenComplete(() {
      print("Event added to the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  Future<void> updateEventData(EventInfo eventInfo, String uid) async {
    DocumentReference documentReferencer = mainCollection.doc(eventInfo.id);

    Map<String, dynamic> data = eventInfo.toJson();

    await documentReferencer.update(data).whenComplete(() {
      print("Event updated in the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  Future<void> catchEvent(
      EventInfo eventInfo, String uid, String eventLink) async {
    DocumentReference documentReferencer = mainCollection.doc(eventInfo.id);

    Map<String, dynamic> data = eventInfo.toJson();

    await documentReferencer.update({
      'occupied': true,
      'interID': uid,
      'link': eventLink
    }).catchError((e) => print(e));
  }

  Future<void> deleteEvent({String id}) async {
    DocumentReference documentReferencer = mainCollection.doc(id);

    await documentReferencer.delete().catchError((e) => print(e));
  }

  Stream<QuerySnapshot> retrieveRequestEvents(String uid) {
    Stream<QuerySnapshot> myClasses = mainCollection
        .where('customerID', isEqualTo: uid)
        .where('occupied', isEqualTo: false)
        .snapshots();

    return myClasses;
  }

  Stream<QuerySnapshot> retrieveOccupiedEvents(String uid, bool isInter) {
    Stream<QuerySnapshot> myClasses = (isInter)
        ? mainCollection
            .where('interID', isEqualTo: uid)
            // .orderBy('start')
            .snapshots()
        : mainCollection
            .where('customerID', isEqualTo: uid)
            .where('occupied', isEqualTo: true)
            // .orderBy('start')
            .snapshots();

    return myClasses;
  }

  Stream<QuerySnapshot> retrieveAllEvents() {
    Stream<QuerySnapshot> myClasses =
        mainCollection.where('occupied', isEqualTo: false).snapshots();

    return myClasses;
  }

  Stream<QuerySnapshot> retrieveCustomerhistoryEvents(String uid) {
    Stream<QuerySnapshot> myClasses = mainCollection
        .where('customerID', isEqualTo: uid)
        .where('date', isLessThan: DateTime.now())
        .snapshots();
    return myClasses;
  }

  Stream<QuerySnapshot> retrieveInterhistoryEvents(String uid) {
    Stream<QuerySnapshot> myClasses = mainCollection
        .where('interID', isEqualTo: uid)
        .where('date', isLessThan: DateTime.now())
        .snapshots();

    return myClasses;
  }
}
