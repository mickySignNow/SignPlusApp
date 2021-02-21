import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/models/InterData.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/style.dart';

import 'AdminPage.dart';

class InterAdminDashboard extends StatefulWidget {
  @override
  _InterAdminDashboardState createState() => _InterAdminDashboardState();
}

class _InterAdminDashboardState extends State<InterAdminDashboard> {
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
    var res = await FirebaseConstFunctions.getAllInters.call({'': ''});
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
                        emailPwTemplate(context, emailController, 'הזן מייל',
                            Icon(Icons.mail)),
                        SizedBox(
                          height: 15,
                        ),
                        emailPwTemplate(context, passwordController,
                            'הזן סיסמא', Icon(Icons.lock_outline_sharp)),
                        SizedBox(
                          height: 15,
                        ),
                        adminTextField(
                            main: AdminPage(
                                adminPannel: 'inters',
                                functionName: 'CreateInter'),
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
                                adminPannel: 'inter',
                                functionName: 'CreateInter'),
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
                                adminPannel: 'inter',
                                functionName: 'CreateInter'),
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
                                adminPannel: 'inter',
                                functionName: 'CreateInter'),
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
                          decoration:
                              InputDecoration(hintText: 'הזנ/י תאריך לידה'),
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
                                initialDate: birthDate ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              birthDate = date;
                              birthDateString = date.toIso8601String();
                              return date;
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                        confirmationButton(
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
                            }),
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
                        var user = InterData.fromMap(snapshot.data[index]);
                        print(user.UsertoJson());
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(actions: [
                                  FlatButton(
                                    onPressed: () async {
                                      await FirebaseConstFunctions.deleteUser
                                          .call({'uid': user.interpreterID});
                                    },
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
                                    Text(user.fullName),
                                    SizedBox(width: 10),
                                    Text(user.interpreterID),
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
