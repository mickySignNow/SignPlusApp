import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _deafCheck = false;
  bool _translatorCheck = false;

  bool _validate = true;

  FirebaseAuth auth = FirebaseAuth.instance;

  File myFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildNavBar(context: context, title: 'admin screen'),
        body: SafeArea(
            child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 24, spreadRadius: 24)
            ],
            color: Color(0xffFAFAFA).withOpacity(0.9),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Center(
                    child: Container(
                      margin: kIsWeb
                          ? EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 4,
                              16,
                              MediaQuery.of(context).size.width / 4,
                              0)
                          : EdgeInsets.fromLTRB(20, 16, 15, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xffFFFFFF)),
                      child: CheckboxListTile(
                        title: Text(
                          'אני חירש.ת ',
                          textAlign: TextAlign.center,
                        ),
                        secondary: Image.asset(
                          'images/Ear Icon.png',
                          height: 35,
                        ),
                        subtitle: !_validate
                            ? Text(
                                'אנא סמנ/י',
                                style: homePageText(
                                    12, Colors.red, FontWeight.normal),
                              )
                            : null,
                        activeColor: Colors.blue,
                        value: _deafCheck,
                        onChanged: (value) {
                          setState(() {
                            _translatorCheck = !value;
                            _deafCheck = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: kIsWeb
                        ? EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 4,
                            16,
                            MediaQuery.of(context).size.width / 4,
                            0)
                        : EdgeInsets.fromLTRB(20, 8, 15, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xffFFFFFF)),

                    /// checkBox "אני מתורגמן"
                    child: CheckboxListTile(
                      title: Text(
                        'אני מתורגמנ.ית ',
                        textAlign: TextAlign.center,
                      ),
                      secondary: Image.asset(
                        'images/Translator Icon.png',
                        height: 35,
                      ),
                      subtitle: !_validate
                          ? Text(
                              'אנא סמנ/י',
                              style: homePageText(
                                  12, Colors.red, FontWeight.normal),
                            )
                          : null,
                      activeColor: Colors.blue,
                      value: _translatorCheck,
                      onChanged: (value) {
                        setState(() {
                          _deafCheck = !value;
                          _translatorCheck = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              emailPwTemplate(
                  context, emailController, 'הזן מייל', Icon(Icons.mail)),
              SizedBox(
                height: 15,
              ),
              emailPwTemplate(context, passwordController, 'הזן סיסמא',
                  Icon(Icons.lock_outline_sharp)),
              SizedBox(
                height: 15,
              ),
              confirmationButton(
                  context: context,
                  auth: FirebaseAuth.instance,
                  emailController: emailController,
                  passwordController: passwordController,
                  onTap: () {
                    auth
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((userCred) {
                      var CreateCustomer = FirebaseFunctions.instance
                          .httpsCallable('CreateCustomer');
                      CreateCustomer.call([
                        {
                          'customerID': userCred.user.uid,
                          'cardID': 12345678,
                          'age': 18,
                          'orginizationID': Random().nextInt(999) + 1000
                        }
                      ]);
                      userCred.user.updateProfile(displayName: 'user');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (con) => AdminPage()));
                    });
                    route:
                    MaterialPageRoute(builder: (con) => AdminPage());
                  },
                  text: 'הוסף'),
              InkWell(
                onTap: () async {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    final input =
                        File(result.files.first.bytes.toString()).openRead();
                    final fields = await input.transform(utf8.decoder);
                    print(fields.toList());

                    final newfield =
                        fields.transform(new CsvToListConverter()).toList();

                    print(newfield);

                    print(result.files[0].name);
                  } else {
                    // User canceled the picker
                  }
                },
                child: Container(
                  child: Text(
                    'open file picker',
                    style: TextStyle(decoration: TextDecoration.none),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
