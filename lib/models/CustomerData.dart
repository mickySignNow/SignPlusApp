import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/tabbedPage.dart';

class CustomerData {
  String communicationMethod;
  String customerID;
  int identityNumber;
  int code;
  String address;
  bool disabled;
  String fullName;
  String birthDate;
  int phone;
  String password;
  String role;

  CustomerData(
      {@required this.role,
      @required this.customerID,
      @required this.identityNumber,
      @required this.communicationMethod,
      @required this.password,
      @required this.phone,
      @required this.address,
      @required this.birthDate,
      @required this.code,
      @required this.disabled,
      @required this.fullName});

  CustomerData.fromMap(Map snapshot)
      : role = snapshot['rolw'] ?? '',
        customerID = snapshot['customerID'] ?? '',
        identityNumber = snapshot['identityNumber'],
        address = snapshot['address'],
        phone = snapshot['phone'],
        code = snapshot['code'],
        disabled = snapshot['disabled'],
        birthDate = snapshot['birthDate'],
        password = snapshot['password'],
        communicationMethod = snapshot['communicationMethod'],
        fullName = snapshot['fullName'] ?? '';

  UsertoJson() {
    return {
      'communicationMethod': communicationMethod,
      'customerID': customerID,
      'identityNumber': identityNumber,
      'code': code,
      'disabled': disabled,
      'birthDate': birthDate,
      'phone': phone,
      'password': password,
      'address': address,
      'fullName': fullName,
      'role': role,
    };
  }
}
