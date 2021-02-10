import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:csv/csv.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/pages/admin/TabbedAdmin.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class AdminPage extends StatefulWidget {
  String adminPannel;
  String functionName;
  AdminPage({@required this.adminPannel, @required this.functionName});
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hoursController = TextEditingController();
  final contactManController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final workingHoursController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  final descController = TextEditingController();
  final cardIDController = TextEditingController();

  var email = '';
  var contactMan = '';
  var hours = '';
  var phone = '';
  var address = '';
  var workingHours = '';
  var code = '';
  var name = '';
  DateTime birthDate = DateTime(1996);
  var birthDateString = '';
  var password = '';
  var desc = '';
  var cardID;

  bool filledEmail = true;
  bool filledContactMan = true;
  bool filledHours = true;
  bool filledPhone = true;
  bool filledAddress = true;
  bool filledWorkingHours = true;
  bool filledCode = true;
  bool filledName = true;
  bool filledCard = true;
  bool filledDesc = true;

  bool addPressed = true;

  bool _deafCheck = false;
  bool _translatorCheck = false;

  bool _validate = true;

  FirebaseAuth auth = FirebaseAuth.instance;

  File myFile;

  UserCredential userCred;

  @override
  Widget build(BuildContext context) {
    print(widget.functionName);
    return Scaffold(
        appBar: buildNavBar(
            context: context, title: 'admin screen ${widget.adminPannel}'),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 24, spreadRadius: 24)
              ],
              color: Color(0xffFAFAFA).withOpacity(0.9),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                (widget.functionName == 'CreateCustomer')
                    ? Column(
                        children: [
                          emailPwTemplate(context, emailController, 'הזן מייל',
                              Icon(Icons.mail)),
                          SizedBox(
                            height: 10,
                          ),
                          emailPwTemplate(context, passwordController,
                              'הזן סיסמא', Icon(Icons.lock_outline_sharp)),
                          SizedBox(
                            height: 10,
                          ),
                          adminTextField(
                            inputType: TextInputType.number,
                            errorMessage: 'אנא הזן קוד ארגון',
                            hint: 'אנא הזן קוד ארגון',
                            filled: filledCode,
                            controller: codeController,
                            main: AdminPage(
                                adminPannel: 'customer',
                                functionName: 'CreateCustomer'),
                            textInput: code,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          adminTextField(
                            inputType: TextInputType.number,
                            errorMessage: 'אנא הזן מספר פלאפון',
                            hint: 'אנא הזן מספר פלאפון',
                            filled: filledPhone,
                            controller: phoneController,
                            main: AdminPage(
                                adminPannel: 'customer',
                                functionName: 'CreateCustomer'),
                            textInput: phone,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          adminTextField(
                            inputType: TextInputType.streetAddress,
                            errorMessage: 'אנא הזן כתובת',
                            hint: 'אנא הזן כתובת',
                            filled: filledAddress,
                            controller: addressController,
                            main: AdminPage(
                                adminPannel: 'customer',
                                functionName: 'CreateCustomer'),
                            textInput: address,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          adminTextField(
                            inputType: TextInputType.text,
                            errorMessage: 'אנא הזן שם מלא',
                            hint: 'אנא הזן שם מלא',
                            filled: filledName,
                            controller: nameController,
                            main: AdminPage(
                                adminPannel: 'customer',
                                functionName: 'CreateCustomer'),
                            textInput: name,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DateTimeField(
                            decoration: InputDecoration(
                                hintText: 'הזנ/י תאריך ושעה רצויים'),
                            resetIcon: null,
                            onEditingComplete: () => {
                              setState(() {
                                birthDateController.clear();
                              }),
                            },
                            controller: birthDateController,
                            format: DateFormat('dd-MM-yyyy HH:mm'),
                            textAlign: TextAlign.center,
                            onChanged: (value) => {
                              setState(() {
                                widget.createState();
                              })
                            },
                            enabled: true,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                builder: (context, child) =>
                                    Localizations.override(
                                  context: context,
                                  locale: Locale('he'),
                                  child: child,
                                ),
                                context: context,
                                firstDate: birthDate ?? DateTime(1920),
                                lastDate: DateTime(2022),
                                initialDate: birthDate ?? DateTime.now(),
                              );
                              print(DateFormat('yyyy/MM/dd').format(date));
                              if (date != null) birthDate = date;
                              birthDateString = birthDate.toString();

                              return currentValue;
                            },
                          )
                        ],
                      )
                    : (widget.functionName == 'CreateOrginization')
                        ? Column(
                            children: [
                              adminTextField(
                                  main: AdminPage(
                                      adminPannel: widget.adminPannel,
                                      functionName: widget.functionName),
                                  controller: emailController,
                                  textInput: email,
                                  filled: filledEmail,
                                  hint: 'הזן מייל של ארגון',
                                  errorMessage: 'לא הוזן מייל ארגון',
                                  inputType: TextInputType.emailAddress),
                              SizedBox(
                                height: 10,
                              ),
                              adminTextField(
                                  main: AdminPage(
                                      adminPannel: widget.adminPannel,
                                      functionName: widget.functionName),
                                  controller: hoursController,
                                  textInput: hours,
                                  filled: filledHours,
                                  hint: 'הזן מספר שעות לארגון',
                                  errorMessage: 'לא הוזן מספר שעות לארגון',
                                  inputType: TextInputType.number),
                              SizedBox(
                                height: 10,
                              ),
                              adminTextField(
                                  main: AdminPage(
                                      adminPannel: widget.adminPannel,
                                      functionName: widget.functionName),
                                  controller: addressController,
                                  textInput: address,
                                  filled: filledAddress,
                                  hint: 'הזן כתובת של ארגון',
                                  errorMessage: 'לא הוזן כתובת ארגון',
                                  inputType: TextInputType.text),
                              SizedBox(
                                height: 10,
                              ),
                              adminTextField(
                                  main: AdminPage(
                                      adminPannel: widget.adminPannel,
                                      functionName: widget.functionName),
                                  controller: phoneController,
                                  textInput: phone,
                                  filled: filledPhone,
                                  hint: 'הזן מספר של ארגון',
                                  errorMessage: 'לא הוזן מספר ארגון',
                                  inputType: TextInputType.number),
                              SizedBox(
                                height: 10,
                              ),
                              adminTextField(
                                  main: AdminPage(
                                      adminPannel: widget.adminPannel,
                                      functionName: widget.functionName),
                                  controller: contactManController,
                                  textInput: contactMan,
                                  filled: filledContactMan,
                                  hint: 'הזן איש קשר של ארגון',
                                  errorMessage: 'לא הוזן איש קשר של  ארגון',
                                  inputType: TextInputType.text),
                              SizedBox(
                                height: 10,
                              ),
                              adminTextField(
                                  main: AdminPage(
                                      adminPannel: widget.adminPannel,
                                      functionName: widget.functionName),
                                  controller: workingHoursController,
                                  textInput: workingHours,
                                  filled: filledWorkingHours,
                                  hint: 'הזן שעות עבודה של ארגון',
                                  errorMessage: 'לא שעות עבודה שם ארגון',
                                  inputType: TextInputType.text),
                              SizedBox(
                                height: 10,
                              ),
                              adminTextField(
                                  main: AdminPage(
                                      adminPannel: widget.adminPannel,
                                      functionName: widget.functionName),
                                  controller: codeController,
                                  textInput: code,
                                  filled: filledCode,
                                  hint: 'הזן קוד ארגון',
                                  errorMessage: 'הזן קוד ארגון',
                                  inputType: TextInputType.number),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : Column(
                              children: [
                                emailPwTemplate(context, emailController,
                                    'הזן מייל', Icon(Icons.mail)),
                                SizedBox(
                                  height: 15,
                                ),
                                emailPwTemplate(
                                    context,
                                    passwordController,
                                    'הזן סיסמא',
                                    Icon(Icons.lock_outline_sharp)),
                                SizedBox(
                                  height: 15,
                                ),
                                adminTextField(
                                    main: AdminPage(
                                        adminPannel: widget.adminPannel,
                                        functionName: widget.functionName),
                                    controller: nameController,
                                    textInput: name,
                                    filled: filledName,
                                    hint: 'הזן שם מלא',
                                    errorMessage: 'הזן שם מלא',
                                    inputType: TextInputType.text),
                                SizedBox(
                                  height: 10,
                                ),
                                adminTextField(
                                    main: AdminPage(
                                        adminPannel: widget.adminPannel,
                                        functionName: widget.functionName),
                                    controller: phoneController,
                                    textInput: phone,
                                    filled: filledPhone,
                                    hint: 'הזן מספר פלאפון',
                                    errorMessage: 'הזן מספר פלאפון',
                                    inputType: TextInputType.number),
                                SizedBox(
                                  height: 10,
                                ),
                                adminTextField(
                                    main: AdminPage(
                                        adminPannel: widget.adminPannel,
                                        functionName: widget.functionName),
                                    controller: cardIDController,
                                    textInput: cardID,
                                    filled: filledCard,
                                    hint: 'הזן תעודת זהות',
                                    errorMessage: 'הזן תעודת זהות',
                                    inputType: TextInputType.number),
                                SizedBox(
                                  height: 10,
                                ),
                                adminTextField(
                                    main: AdminPage(
                                        adminPannel: widget.adminPannel,
                                        functionName: widget.functionName),
                                    controller: addressController,
                                    textInput: address,
                                    filled: filledAddress,
                                    hint: 'הזן כתובת ',
                                    errorMessage: 'הזן כתובת ',
                                    inputType: TextInputType.text),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                DateTimeField(
                                  decoration: InputDecoration(
                                      hintText: 'הזנ/י תאריך לידה'),
                                  format: DateFormat('dd-MM-yy'),
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        builder: (context, child) =>
                                            Localizations.override(
                                              context: context,
                                              locale: Locale('he'),
                                              child: child,
                                            ),
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            birthDate ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      birthDate = date;
                                      birthDateString = date.toIso8601String();
                                      return date;
                                    } else {
                                      return currentValue;
                                    }
                                  },
                                )
                              ],
                            ) ??
                            Text('something was null'),
                (widget.functionName == 'CreateCustomer')
                    ? Row(
                        children: [
                          confirmationButton(
                              context: context,
                              auth: FirebaseAuth.instance,
                              emailController: emailController,
                              passwordController: passwordController,
                              onTap: addPressed
                                  ? () {
                                      addPressed = false;
                                      password = passwordController.text;
                                      email = emailController.text;
                                      address = addressController.text;
                                      phone = phoneController.text;
                                      name = nameController.text;
                                      code = codeController.text;
                                      if (email.isEmpty ||
                                          password.isEmpty ||
                                          name.isEmpty ||
                                          address.isEmpty ||
                                          phone.isEmpty ||
                                          code.isEmpty) {
                                        if (email.isEmpty) {
                                          setState(() {
                                            filledEmail = false;
                                          });
                                        }
                                        if (name.isEmpty) {
                                          setState(() {
                                            filledName = false;
                                          });
                                        }
                                        if (address.isEmpty) {
                                          setState(() {
                                            filledAddress = false;
                                          });
                                        }
                                        if (phone.isEmpty) {
                                          setState(() {
                                            filledPhone = false;
                                          });
                                        }
                                      }

                                      setAdminCustomerFunction(
                                        address: address,
                                        birthDate: birthDateString,
                                        name: name,
                                        phone: phone,
                                        context: context,
                                        auth: auth,
                                        email: email,
                                        password: password,
                                        code: int.parse(code),
                                      );
                                    }
                                  : () {},
                              text: 'הוסף'),
                        ],
                      )
                    : (widget.functionName == 'CreateInter')
                        ? confirmationButton(
                            context: context,
                            text: 'הוסף',
                            auth: auth,
                            emailController: emailController,
                            passwordController: passwordController,
                            onTap: () {
                              password = passwordController.text;
                              email = emailController.text;
                              address = addressController.text;
                              phone = phoneController.text;
                              name = nameController.text;
                              code = codeController.text;
                              cardID = cardIDController.text;
                              desc = descController.text;
                              if (email.isEmpty ||
                                  password.isEmpty ||
                                  name.isEmpty ||
                                  address.isEmpty ||
                                  phone.isEmpty ||
                                  cardID.isEmpty ||
                                  desc.isEmpty ||
                                  code.isEmpty) {
                                if (email.isEmpty) {
                                  setState(() {
                                    filledEmail = false;
                                  });
                                }
                                if (name.isEmpty) {
                                  setState(() {
                                    filledName = false;
                                  });
                                }
                                if (address.isEmpty) {
                                  setState(() {
                                    filledAddress = false;
                                  });
                                }
                                if (phone.isEmpty) {
                                  setState(() {
                                    filledPhone = false;
                                  });
                                }
                                if (cardID.isEmpty) {
                                  setState(() {
                                    filledCard = false;
                                  });
                                }
                                if (desc.isEmpty) {
                                  setState(() {
                                    filledDesc = false;
                                  });
                                }
                              }

                              setAdminInterFunction(
                                context: context,
                                auth: auth,
                                password: password,
                                email: email,
                                address: address,
                                phone: phone,
                                name: name,
                                cardID: cardID,
                                desc: desc,
                              );
                            })
                        : confirmationButton(
                            context: context,
                            emailController: emailController,
                            text: 'הוסף ארגון',
                            onTap: () {
                              email = emailController.text;
                              address = addressController.text;
                              phone = phoneController.text;
                              contactMan = contactManController.text;
                              hours = hoursController.text;
                              workingHours = workingHoursController.text;
                              code = codeController.text;
                              if (email.isEmpty ||
                                  phone.isEmpty ||
                                  contactMan.isEmpty ||
                                  workingHours.isEmpty ||
                                  address.isEmpty ||
                                  hours.isEmpty ||
                                  code.isEmpty) {
                                if (email.isEmpty) {
                                  setState(() {
                                    filledEmail = false;
                                  });
                                }
                                if (phone.isEmpty) {
                                  setState(() {
                                    filledPhone = false;
                                  });
                                }
                                if (contactMan.isEmpty) {
                                  setState(() {
                                    filledContactMan = false;
                                  });
                                }
                                if (hours.isEmpty) {
                                  setState(() {
                                    filledHours = false;
                                  });
                                }
                                if (workingHours.isEmpty) {
                                  setState(() {
                                    filledWorkingHours = false;
                                  });
                                }
                                if (code.isEmpty) {
                                  setState(() {
                                    filledCode = false;
                                  });
                                }
                              } else {
                                HttpsCallable createOrginization =
                                    FirebaseFunctions.instance
                                        .httpsCallable('CreateOrginization');
                                var data = {
                                  "fullName": contactMan,
                                  "code": int.parse(code),
                                  "credit": hours,
                                  "email": email,
                                  "phone": phone,
                                  "contactMan": contactMan,
                                  "workingHours": workingHours,
                                  "address": address,
                                  "pricing": 120,
                                };
                                createOrginization.call(data).whenComplete(() {
                                  print('uploaded orgiinization');
                                  try {
                                    auth.signOut();
                                  } catch (e) {
                                    print(e);
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (con) => TabbedAdmin(
                                                initialIndex: 2,
                                              )));
                                });
                              }
                            }),
                // confirmationButton(
                //     context: context,
                //     auth: FirebaseAuth.instance,
                //     emailController: emailController,
                //     passwordController: passwordController,
                //     onTap: () async {
                //       await auth
                //           .createUserWithEmailAndPassword(
                //               email: emailController.text,
                //               password: passwordController.text)
                //           .then((userCred) {
                //         this.userCred = userCred;
                //         userCred.user.updateProfile(displayName: 'inter');
                //         Navigator.pushReplacement(context,
                //             MaterialPageRoute(builder: (con) => AdminPage()));
                //       });
                //       print(userCred.user.email);
                //       if (userCred != null) {
                //         var createInter = FirebaseFunctions.instance
                //             .httpsCallable('CreateInter');
                //         var data = {
                //           'customerID': userCred.user.uid,
                //           'cardID': 12345678,
                //           'age': 18,
                //           'orginizationID': Random().nextInt(999) + 1000
                //         };
                //         print(data);
                //         createInter
                //             .call(data)
                //             .whenComplete(() => print('uploaded inter'));
                //       }
                //
                //       route:
                //       MaterialPageRoute(builder: (con) => AdminPage());
                //     },
                //     text: 'הוסף מתורגמן'),
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
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async {
                    // Prompt the user to enter their email and password
                    try {
                      // auth
                      //     .userChanges()
                      //     .where((user) => user.email == emailController.text)
                      //     .first
                      //     .then((value) => value.delete());

                      print(auth
                          .userChanges()
                          .where((user) => user.email == emailController.text)
                          .forEach((element) {
                        print(element);
                      }));

                      String email = emailController.text.trim();
                      String password = '12345678';

                      // Create a credential
                      EmailAuthCredential credential =
                          EmailAuthProvider.credential(
                              email: email, password: password);
                      // Reauthenticate
                      auth
                          .signInWithCredential(credential)
                          .then((value) => value.user.delete());
                    } catch (err) {
                      print(err);
                    }
                  },
                  child: Container(color: Colors.green, child: Text('delete')),
                ),
              ],
            ),
          )),
        ));
  }
}
