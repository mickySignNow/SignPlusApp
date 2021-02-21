import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/tabbedPage.dart';

class Orginization {
  List<String> ability;
  String contactMan;
  String code;
  String credit;
  bool creditUsed;
  String email;
  String originizationName;
  // List hoursOfWork;
  String phone;
  String address;
  String pricing;
  String workingHours;

  Orginization(
      {@required this.ability,
      @required this.email,
      @required this.phone,
      @required this.credit,
      @required this.creditUsed,
      @required this.code,
      @required this.address,
      @required this.contactMan,
      // @required this.hoursOfWork,
      @required this.pricing,
      @required this.workingHours,
      @required this.originizationName});

  Orginization.fromMap(Map snapshot)
      : phone = snapshot['phone'] ?? '',
        ability = snapshot['ability'] ?? '',
        credit = snapshot['credit'],
        creditUsed = snapshot['creditUsed'] ?? 0.0,
        contactMan = snapshot['contactMan'] ?? '',
        // hoursOfWork = snapshot['hoursOfWork'] ,
        email = snapshot['email'] ?? '',
        pricing = snapshot['pricing'] ?? '',
        address = snapshot['address'] ?? '',
        originizationName = snapshot['fullName'],
        workingHours = snapshot['workingHours'] ?? '',
        code = snapshot['code'] ?? '';

  UsertoJson() {
    return {
      'phone': phone,
      'ability': ability,
      'credit': credit,
      // 'hoursOfWork': hoursOfWork,
      'creditUsed': creditUsed,
      'contactMan': contactMan,
      'email': email,
      'pricing': pricing,
      'address': address,
      'orginizationName': originizationName,
      'workingHours': workingHours,
      'code': code
    };
  }
}
