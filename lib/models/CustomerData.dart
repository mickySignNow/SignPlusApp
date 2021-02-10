import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/tabbedPage.dart';

class CustomerData {
  String email;
  String customerId;
  String cardId;
  bool hasCredit;
  String hourBank;
  bool isActive;
  String fullName;

  CustomerData(
      {@required this.email,
      @required this.customerId,
      @required this.cardId,
      @required this.hasCredit,
      @required this.hourBank,
      @required this.isActive,
      @required this.fullName});

  CustomerData.fromMap(Map snapshot)
      : email = snapshot['email'] ?? '',
        customerId = snapshot['customerId'] ?? '',
        cardId = snapshot['cardId'],
        // location = snapshot['loc'],
        hasCredit = snapshot['hasCredit'],
        hourBank = snapshot['hourBank'],
        isActive = snapshot['isActive'],
        fullName = snapshot['fullName'] ?? '';

  UsertoJson() {
    return {
      'email': email,
      'customerId': customerId,
      'cardId': cardId,
      'hasCredit': hasCredit,
      'hourBank': hourBank,
      'isActive': isActive,
      'fullName': fullName
    };
  }
}
