import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/pages/tabbedPage.dart';

class InterData {
  String email;
  String interId;
  Map<String, dynamic> certificate;
  String speciality;
  bool isActive;
  String fullName;
  double score;
  Map<String, dynamic> hoursOfWork;
  int likes;

  InterData(
      {@required this.email,
      @required this.interId,
      @required this.certificate,
      @required this.speciality,
      @required this.score,
      @required this.likes,
      @required this.hoursOfWork,
      @required this.isActive,
      @required this.fullName});

  InterData.fromMap(Map snapshot)
      : email = snapshot['email'] ?? '',
        interId = snapshot['interId'] ?? '',
        certificate = snapshot['certificate'],
        // location = snapshot['loc'],
        hoursOfWork = snapshot['hoursOfWork'],
        score = snapshot['score'],
        speciality = snapshot['speciality'],
        isActive = snapshot['isActive'],
        likes = snapshot['likes'],
        fullName = snapshot['fullName'] ?? '';

  UsertoJson() {
    return {
      'email': email,
      'interId': interId,
      'certificate': {
        'image': certificate['image'] as String ?? '',
        'id': certificate['id'] as String ?? '',
        'experience': certificate['experience'] as String ?? ''
      },
      'hoursOfWork': {
        'startTime': hoursOfWork['startTime'] as String ?? '',
        'endTime': hoursOfWork['endTime'] as String ?? '',
        'days': hoursOfWork['days'] as int ?? ''
      },
      'fullName': fullName,
      'isActive': isActive,
      'speciality': speciality,
      'likes': likes,
      'score': score
    };
  }
}
