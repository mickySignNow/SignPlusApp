import 'package:cloud_functions/cloud_functions.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/models/InterData.dart';
import 'package:sign_plus/models/Originization.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/style.dart';

import 'AdminPage.dart';
import 'TabbedAdmin.dart';

class OrginizationAdminDashboard extends StatefulWidget {
  @override
  _OrginizationAdminDashboardState createState() =>
      _OrginizationAdminDashboardState();
}

class _OrginizationAdminDashboardState
    extends State<OrginizationAdminDashboard> {
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

  bool addOrSee = false;

  setAdminQuery() async {
    var res = await FirebaseConstFunctions.getAllOrginizations.call({'': ''});
    return res.data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: RaisedButton(
            onPressed: () {
              setState(() {
                addOrSee = !addOrSee;
              });
            },
            child: Text(addOrSee ? 'לצפייה בכל המשתמשים' : 'להוספה'),
          ),
        ),
        addOrSee
            ? Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        adminTextField(
                            main: AdminPage(
                                adminPannel: 'Orginization',
                                functionName: 'CreateOrginization'),
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
                                adminPannel: 'Orginization',
                                functionName: 'CreateOrginization'),
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
                                adminPannel: 'Orginization',
                                functionName: 'CreateOrginization'),
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
                                adminPannel: 'Orginization',
                                functionName: 'createOrginization'),
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
                                adminPannel: 'Orginization',
                                functionName: 'CreateOrginization'),
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
                                adminPannel: 'Orginization',
                                functionName: 'CreateOrginzation'),
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
                                adminPannel: 'Orginization',
                                functionName: 'CreateOrginization'),
                            controller: codeController,
                            textInput: code,
                            filled: filledCode,
                            hint: 'הזן קוד ארגון',
                            errorMessage: 'הזן קוד ארגון',
                            inputType: TextInputType.number),
                        SizedBox(
                          height: 10,
                        ),
                        confirmationButton(
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
                                var data = {
                                  "orginizationName": contactMan,
                                  "code": int.parse(code),
                                  "credit": hours,
                                  "email": email,
                                  "phone": phone,
                                  "contactMan": contactMan,
                                  "workingHours": workingHours,
                                  "address": address,
                                  "pricing": 120,
                                };
                                FirebaseConstFunctions.createOrginization
                                    .call(data)
                                    .whenComplete(() {
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
                            })
                      ],
                    ),
                  ),
                ),
              )
            : Expanded(
                child: FutureBuilder(
                  future: setAdminQuery(),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    print(snapshot.data.length);
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        print(snapshot.data[index]);
                        var user = Orginization.fromMap(snapshot.data[index]);
                        print(user.UsertoJson());
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(actions: [
                                  FlatButton(
                                    onPressed: () {},
                                    child: Text('מחק'),
                                  ),
                                  FlatButton(
                                    onPressed: () {},
                                    child: Text('עדכון'),
                                  )
                                ]);
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(user.originizationName),
                                    SizedBox(width: 10),
                                    Text(user.address),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(user.phone),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('פלאפון :')
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                        //   Container(
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(5),
                        //       color: Colors.white,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.5),
                        //           spreadRadius: 5,
                        //           blurRadius: 7,
                        //           offset:
                        //               Offset(0, 3), // changes position of shadow
                        //         ),
                        //       ]),
                        //   padding: EdgeInsets.all(5),
                        //   margin:
                        //       EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        //   child: Column(children: [
                        //     Flexible(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(user.fullName),
                        //           SizedBox(
                        //             width: 5,
                        //           ),
                        //           Text(user.cardID)
                        //         ],
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     // Flexible(
                        //     //     child: Row(
                        //     //   mainAxisAlignment: MainAxisAlignment.end,
                        //     //   children: [
                        //     //     Text(user.identityNumber.toString()),
                        //     //     SizedBox(
                        //     //       width: 5,
                        //     //     ),
                        //     //     Text('ת.ז:'),
                        //     //     SizedBox(
                        //     //       width: 20,
                        //     //     ),
                        //     //     Text(user.phone.toString()),
                        //     //     SizedBox(
                        //     //       width: 5,
                        //     //     ),
                        //     //     Text('פלאפון'),
                        //     //   ],
                        //     // )),
                        //   ]),
                        // );
                      },
                    );
                  },
                ),
              ),
      ],
    ));
  }
}
