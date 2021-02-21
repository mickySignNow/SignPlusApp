import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/pages/admin/AdminPage.dart';
import 'package:sign_plus/pages/admin/TabbedAdmin.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/style.dart';

/**
 * A function to validate email
 * @param value - the email the to validate before sending validation
 * return String - if No mail was typed: "can't add empty email" , if mail was typed incorrectly: "invalid email", if mail is correct in the right form return null
 * */
// String _validateEmail(String value) {
//   if (value != null) {
//     value = value.trim();
//
//     if (value.isEmpty) {
//       return 'Can\'t add an empty email';
//     } else {
//       final regex = RegExp(
//           r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
//       final matches = regex.allMatches(value);
//       for (Match match in matches) {
//         if (match.start == 0 && match.end == value.length) {
//           return null;
//         }
//       }
//     }
//   } else {
//     return 'Can\'t add an empty email';
//   }
//
//   return 'Invalid email';
// }

// TODO: Storage push and pull functions

uploadNewUser() async {
  FirebaseAuth _auth = await FirebaseAuth.instance;
  var user = await _auth.currentUser;

  String email = user.email;
  String uid = user.uid;
  String name = user.displayName;
  String picture = user.photoURL;
  String timeStamp = DateTime.now().toIso8601String();
  String token = await user.getIdToken();

  return {
    "email": email,
    "ID": uid,
    'name': name,
    "picture": picture,
    'timeStamp': timeStamp,
    'IDTOKEN': token
  };

  // Firestore.instance.collection('users').doc(email).set({
  //   "email": email,
  //   "ID": uid,
  //   'name': name,
  //   "picture": picture,
  //   'timeStamp': timeStamp
  // });
}

String catchDialogText(String date, String hour, String length) {
  return ' האם לשריין פגישה בתאריך  ' +
      date +
      '\n' +
      ' למשך ' +
      length +
      ' דקות ' +
      '\n' +
      ' בשעה: ' +
      hour +
      '\n';
}

String testDateTime(DateTime date, DateTime hour) {
  if (date.isBefore(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)))
    return 'אנא הכנס/י תאריך עתידי';
  else {
    if (date.day == DateTime.now().day && hour.hour >= DateTime.now().hour + 2)
      return 'אנא הכנס שעה עתידית';
    else {
      /// todo: add time range
      return '';
    }
  }
}

bool testTime(int startTime, DateTime date) {
  if (date.compareTo(DateTime.now()) != 0) return false;

  var timeNow = TimeOfDay.fromDateTime(DateTime.now());
  final now = timeNow.hour * 60 + timeNow.minute;
  final eventTime = (DateTime.fromMillisecondsSinceEpoch(startTime).hour * 60 +
          DateTime.fromMillisecondsSinceEpoch(startTime).minute) -
      10;

  return now > eventTime;
}

String phoneToLocal(String phone) {
  String areaCode = '+972 ';
  areaCode += phone.substring(1, 4) + ' ';
  print(areaCode);
  areaCode += phone.substring(4, 7) + ' ';
  print(areaCode);
  areaCode += phone.substring(7);
  print(areaCode);

  return areaCode;
}

setAdminCustomerFunction({
  BuildContext context,
  FirebaseAuth auth,
  String email,
  String password,
  int code,
  String phone,
  String address,
  String name,
  String birthDate,
}) async {
  var userCredentials;
  print('entered admin function');
  var data = Map();
  var codeValidation =
      FirebaseFunctions.instance.httpsCallable('CodeValidation');
  var res = await codeValidation.call({'code': code});
  if (!res.data) {
    informationAlertDialog(context, 'קוד שגוי אנא הזן קוד נכון', 'אישור');
  } else {
    if (email.isEmpty)
      data = {
        "customerID": auth.currentUser.uid,
        "cardID": password,
        "code": code,
        "phone": phone,
        "address": address,
        "identityNumber": password,
        "password": password,
        "fullName": name,
        "birthDate": birthDate,
        'communicationMethod': 'phone'
      };
    else {
      data = {
        "customerID": auth.currentUser.uid,
        "cardID": password,
        "code": code,
        "phone": phone,
        "address": address,
        "identityNumber": password,
        "password": password,
        "fullName": name,
        "birthDate": birthDate,
        'communicationMethod': 'email'
      };
    }
    await FirebaseConstFunctions.createCustomerEmailPhone
        .call(data)
        .whenComplete(() {
      print('uploaded user');
      try {
        auth.signOut();
      } catch (e) {
        print(e);
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (con) => TabbedAdmin(
                    initialIndex: 0,
                  )));
    });

    // if (email.isEmpty) {
    //   print('loging in via phone');
    //
    //   print(phoneToLocal(phone));
    //
    //   var verifier = RecaptchaVerifier(
    //     size: RecaptchaVerifierSize.compact,
    //     theme: RecaptchaVerifierTheme.dark,
    //   );
    //   final res = await auth
    //       .signInWithPhoneNumber(phoneToLocal(phone), verifier)
    //       .whenComplete(() => print('logged in by phone'))
    //       .catchError((e) => print(e));
    //
    //   await showDialog(
    //     context: context,
    //     builder: (context) {
    //       TextEditingController controller = TextEditingController();
    //       return AlertDialog(
    //         content: Column(
    //           children: [
    //             TextFormField(
    //               controller: controller,
    //             ),
    //             RaisedButton(
    //               child: Text('אישור'),
    //               onPressed: () {
    //                 res.confirm(controller.text).catchError((e) => print(e));
    //               },
    //             )
    //           ],
    //         ),
    //       );
    //     },
    //   );
    //   // final AuthCredential credential = PhoneAuthProvider.getCredential(
    //   //   verificationId: res.verificationId,
    //   //   smsCode: ,
    //   // );
    //   // auth.signInWithCredential(credential).catchError((e) => print(e));
    //   // UserCredential cred = await res.confirm(res.verificationId);
    // } else
    //   await auth
    //       .createUserWithEmailAndPassword(email: email, password: password)
    //       .catchError((e) => print('failed creating user ' + e));
    //
    // var createUser = FirebaseFunctions.instance.httpsCallable('CreateCustomer');
    // var data = {
    //   "customerID": auth.currentUser.uid,
    //   "cardID": password,
    //   "code": code,
    //   "phone": phone,
    //   "address": address,
    //   "identityNumber": password,
    //   "password": password,
    //   "fullName": name,
    //   "birthDate": birthDate,
    // };
    //
    // print(data);
    // createUser.call(data).whenComplete(() {
    //   print('uploaded user');
    //   try {
    //     auth.signOut();
    //   } catch (e) {
    //     print(e);
    //   }
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (con) => TabbedAdmin(
    //                 initialIndex: 0,
    //               )));
    // });
  }
}

setAdminInterFunction({
  BuildContext context,
  FirebaseAuth auth,
  String email,
  String password,
  String phone,
  String address,
  String name,
  String birthDate,
  String cardID,
  String desc,
}) async {
  var createUser = FirebaseConstFunctions.createInter;

  var data = {
    'avarage-rating': null,
    'hours-of-work': [],
    'interID': auth.currentUser.uid ?? '',
    'phone': phone,
    'cardID': cardID,
    'address': address,
    'identityNumber': cardID,
    'password': password,
    'fullName': name,
    'desc': desc
  };
  print(data);
  await createUser.call(data).whenComplete(() {
    print('uploaded inter');
    try {
      auth.signOut();
    } catch (e) {
      print(e);
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (con) => TabbedAdmin(
                  initialIndex: 1,
                )));
  });
}

/**
 * a method that opens the Date picker at the textEditing Field
 * @param context - build context
 * */
_selectDate({BuildContext context, StatefulWidget main}) async {
  DateTime selectedDate = DateTime.now();
  TextEditingController textControllerDate;
  var date;

  /// save picker as variable for use of picked value
  final DateTime picked = await DatePicker.showDatePicker(context,
      locale: LocaleType.heb,
      minTime: DateTime(1930),
      maxTime: DateTime(2050),
      currentTime: DateTime.now());

  /// if picked is null --> picker wasn't opened
  /// if picker is same as default --> picker wasnt changed
  if (picked != null && picked != selectedDate) {
    /// set new state and fill input date with new data
    main.createState().setState(() {
      selectedDate = picked;

      textControllerDate.text = DateFormat.yMMMd().format(selectedDate);
      date = selectedDate.toIso8601String();
      return date;
    });
  } else {
    textControllerDate.text = DateFormat.yMMMd().format(selectedDate);
  }
}
