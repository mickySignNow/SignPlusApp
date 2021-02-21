import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/tabbedPage.dart';

class InterData {
  String desc;
  String interpreterID;
  String role;
  String identityNumber;
  bool disabled;
  String password;
  String fullName;
  double avarageRating;
  // List hoursOfWork;
  String phone;
  String address;
  String cardID;

  InterData(
      {@required this.desc,
      @required this.cardID,
      @required this.phone,
      @required this.identityNumber,
      @required this.password,
      @required this.disabled,
      @required this.address,
      @required this.role,
      // @required this.hoursOfWork,
      @required this.avarageRating,
      @required this.interpreterID,
      @required this.fullName});

  InterData.fromMap(Map snapshot)
      : phone = snapshot['phone'] ?? '',
        cardID = snapshot['cardID'] ?? '',
        identityNumber = snapshot['identityNumber'],
        avarageRating = snapshot['avarageRating'] ?? 0.0,
        password = snapshot['password'] ?? '',
        // hoursOfWork = snapshot['hoursOfWork'] ,
        role = snapshot['role'] ?? '',
        interpreterID = snapshot['interpreterID'] ?? '',
        address = snapshot['address'] ?? '',
        disabled = snapshot['disabled'],
        desc = snapshot['desc'] ?? '',
        fullName = snapshot['fullName'] ?? '';

  UsertoJson() {
    return {
      'desc': desc,
      'role': role,
      'identityNumber': identityNumber,
      // 'hoursOfWork': hoursOfWork,
      'disabled': disabled,
      'interpreterID': interpreterID,
      'fullName': fullName,
      'password': password,
      'phone': phone,
      'address': address,
      'cardID': cardID,
      'avarageRating': avarageRating
    };
  }
}
