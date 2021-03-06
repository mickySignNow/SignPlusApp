import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/tabbedPage.dart';

class AppUser {
  String email;
  String uid;
  String role;
  Map<String, dynamic> timeStamp;
  String fullName;
  DateTime creationDate;
  String phone;
  String address;
  double age;
  String gender;
  String language;
  String orginization;

  AppUser(
      {@required this.email,
      @required this.fullName,
      @required this.gender,
      @required this.phone,
      @required this.uid,
      @required this.address,
      @required this.age,
      @required this.language,
      @required this.timeStamp,
      @required this.role,
      @required this.creationDate,
      @required this.orginization});

  AppUser.fromMap(Map snapshot)
      : email = snapshot['email'] ?? '',
        role = snapshot['role'],
        fullName = snapshot['fullName'] ?? '',
        creationDate = snapshot['creationDate'],
        phone = snapshot['phone'] ?? "",
        address = snapshot['address'] ?? '',
        gender = snapshot['gender'] ?? '',
        language = snapshot['language'] ?? '',
        orginization = snapshot['orginization'] ?? '',
        age = snapshot['age'],
        timeStamp = snapshot['timeStamp'],
        uid = snapshot['uid'] ?? '';

  AppUsertoJson() {
    return {
      'email': email,
      'fullName': fullName,
      'creationDate': DateTime.now().toIso8601String(),
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'age': age,
      'gender': gender,
      'language': language,
      'orginization': orginization,
      'role': role,
      'timeStamp': timeStamp,
      'uid': uid
    };
  }
}
