import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/models/CustomerData.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/style.dart';

import 'AdminPage.dart';

class CustomerAdminDashboard extends StatefulWidget {
  @override
  _CustomerAdminDashboardState createState() => _CustomerAdminDashboardState();
}

class _CustomerAdminDashboardState extends State<CustomerAdminDashboard> {
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

  bool addOrSee = false;
  setAdminQuery() async {
    var res = await FirebaseConstFunctions.getAllCustomers.call({'': ''});
    return res.data;
  }

  @override
  Widget build(BuildContext context) {
    print('admin');
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
                        mainAxisSize: MainAxisSize.min,
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
                          ),
                          confirmationButton(
                              context: context,
                              auth: FirebaseAuth.instance,
                              emailController: emailController,
                              passwordController: passwordController,
                              onTap: addPressed
                                  ? () {
                                      setState(() {
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
                                        print(address);
                                        print(birthDateString);
                                        print(name);
                                        print(phone);
                                        print(email);

                                        setAdminCustomerFunction(
                                          address: address,
                                          birthDate: birthDateString,
                                          name: name,
                                          phone: phone,
                                          context: context,
                                          auth: FirebaseAuth.instance,
                                          email: email,
                                          password: password,
                                          code: int.parse(code),
                                        );
                                      });
                                    }
                                  : () {},
                              text: 'הוסף')
                        ],
                      ),
                    ),
                  ),
                )
              : Flexible(
                  child: FutureBuilder(
                    future: setAdminQuery(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      print(snapshot.data.length);
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var user = CustomerData.fromMap(snapshot.data[index]);
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(actions: [
                                    FlatButton(
                                      onPressed: () async {
                                        await FirebaseConstFunctions.deleteUser
                                            .call({'uid': user.customerID});
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
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(children: [
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(user.fullName),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(user.customerID)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(user.identityNumber.toString()),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('ת.ז:'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(user.code.toString()),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('קוד ארגון:'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(user.phone.toString()),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('פלאפון'),
                                  ],
                                )),
                              ]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
