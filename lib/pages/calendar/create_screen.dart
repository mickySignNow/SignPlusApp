import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/date_symbol_data_http_request.dart';
import 'package:intl/intl.dart';
import 'package:sign_plus/StringNDesigns/Strings.dart';
import 'package:sign_plus/models/ODMEvent.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/models/event_info.dart';
import 'package:sign_plus/pages/calendar/dashboard_screen.dart';
import 'package:sign_plus/pages/tabbedPage.dart';
import 'package:sign_plus/resources/color.dart';
import 'package:sign_plus/models/storage.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/StaticObjects.dart';
import 'package:sign_plus/utils/UI.dart';
import 'package:sign_plus/utils/style.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';

import '../WaitingRoom.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  Storage storage = Storage();
  CalendarClient calendarClient = CalendarClient();

  /// textEditing Controllers
  TextEditingController textControllerDate;
  TextEditingController textControllerStartTime;
  TextEditingController textControllerEndTime;
  TextEditingController textControllerTitle;
  TextEditingController textControllerDesc;
  TextEditingController textControllerLocation;
  TextEditingController textControllerAttendee;

  /// focusNodes
  FocusNode textFocusNodeTitle;
  FocusNode textFocusNodeDesc;
  FocusNode textFocusNodeLocation;
  FocusNode textFocusNodeAttendee;

  /// reset all pickers to current
  DateTime selectedDate = DateTime.now();
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();

  final NOW = DateTime.now();

  /// Strings to get the textEditors input
  String currentTitle;
  String currentDesc = 'בחר/י כותרת לפגישה';
  String currentLocation;
  String currentEmail;
  String errorString = '';
  String date;
  String callLength = '';
  String callDesc = '';
  String lengthDrop = 'בחר/י';
  String descDrop = 'בחר/י כותרת לפגישה';

  // List<String> attendeeEmails = [];

  List<calendar.EventAttendee> attendeeEmails = [];

  /// boolean parameters to maintain editing
  bool isEditingDate = false;
  bool isEditingStartTime = false;
  bool islength = false;
  bool isEditingBatch = false;
  bool isEditingTitle = false;
  bool isEditingLength = false;
  bool isEditingDesc = false;
  // bool isEditingEmail = false;
  // bool isEditingLink = false;
  bool isErrorTime = false;
  // bool shouldNofityAttendees = false;
  // bool hasConferenceSupport = false;
  bool isButtonShowing = true;
  bool buttonAmin = false;

  bool isOnDemand = false;
  bool isSchedule = false;

  /// summary of all boolean parameters
  bool isDataStorageInProgress = false;

  var abilities;

  String name = '', title = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Map<String, String> nameTitle = {'': ''};
  bool didChangeName = true;
  bool didChangeTitle = true;
  bool isEditing = false;

  bool inProgress = false;

  /**
    * a method that opens the timepicker from textediting feild
    * @param context - build context
    */
  _selectStartTime(BuildContext context) async {
    final picked = await DatePicker.showTimePicker(context,
        currentTime: DateTime.now(), showSecondsColumn: false);

    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        textControllerStartTime.text =
            DateFormat('HH:mm').format(selectedStartTime);

        print(DateFormat('yyyy/MM/dd - HH:mm').format(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedStartTime.hour,
          selectedStartTime.minute,
        )));
      });
    } else {
      setState(() {
        textControllerStartTime.text =
            DateFormat('HH:mm').format(selectedStartTime);
      });
    }
  }

/**
 * a method to validate if title is empty
 * @param value - the value from textField
 * return - if empty - 'Title can\'t be empty' else - null
 * */

  String _validateTitle(String value) {
    if (value != null) {
      value = value?.trim();
      if (value.isEmpty) {
        return 'נא למלא כותרת';
      }
    } else {
      return 'נא למלא כותרת';
    }

    return null;
  }

  initAbilities() async {
    abilities =
        await FirebaseConstFunctions.getOrginizationAbilty.call({'': ''});
  }

  @override
  void initState() {
    /// init controllers
    textControllerDate = TextEditingController();
    textControllerStartTime = TextEditingController();
    textControllerEndTime = TextEditingController();
    textControllerTitle = TextEditingController();
    textControllerDesc = TextEditingController();
    textControllerLocation = TextEditingController();
    textControllerAttendee = TextEditingController();

    /// FocusNodes init
    textFocusNodeTitle = FocusNode();
    textFocusNodeDesc = FocusNode();
    textFocusNodeLocation = FocusNode();
    textFocusNodeAttendee = FocusNode();

    Timer timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        buttonAmin = !buttonAmin;
      });
    });
    initAbilities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _auth = FirebaseAuth.instance;
    String userId = _auth.currentUser.uid;
    String userMail = _auth.currentUser.email;

    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;
    bool isWeb = (pageWidth > 700);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNavBar(context: context, title: 'קביעת שיחה עם מתורגמן'),
      // AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   iconTheme: IconThemeData(
      //     color: Colors.grey, //change your color here
      //   ),
      //   title: Text(
      //     'קביעת שיחה עם מתורגמן',
      //     style: TextStyle(
      //       color: CustomColor.dark_blue,
      //       fontSize: 22,
      //     ),
      //   ),
      // ),
      body: isButtonShowing
          ? Center(
              child: Container(
                width: isWeb ? pageWidth / 3 + 10 : pageWidth - 20,
                height: isWeb ? pageHeight / 2 + 10 : pageHeight / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'להזמנת שיחה לחצו ',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: pageWidth / 3,
                      height: pageHeight / 3,
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: buttonAmin
                                ? Colors.transparent
                                : Colors.orange.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.blueAccent,
                      ),
                      child: InkWell(
                        child: Center(
                          child: Image.asset(
                            'images/sign+_white.png',
                            height: (pageHeight / 2) - 25,
                          ),
                        ),
                        onTap: () {
                          // isButtonShowing = false;
                          abilities.data.forEach((ability) {
                            print(ability);
                            if (ability == 'onDemand') {
                              isOnDemand = true;
                            }
                            if (ability == 'schedule') isSchedule = true;
                          });
                          setState(() {
                            isButtonShowing = isSchedule && isOnDemand;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : isSchedule
              ? Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'להזמנת פגישה עם מתורמנית יש למלא את הפרטים הבאים: ',
                                style: TextStyle(
                                  color: Colors.black87,
                                  // fontFamily: 'Raleway',
                                  fontSize: isWeb ? 22 : 12,
                                  fontWeight: FontWeight.bold,
                                  // letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              RichText(
                                text: TextSpan(
                                  text: 'בחר/י תאריך ושעה',
                                  style: TextStyle(
                                    color: CustomColor.dark_cyan,
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: (isWeb)
                                    ? EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                5)
                                    : EdgeInsets.only(left: 10),
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                    hintText: 'הזנ/י תאריך ושעה רצויים',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: CustomColor.sea_blue,
                                          width: 1),
                                    ),
                                  ),
                                  resetIcon: null,
                                  onEditingComplete: () => {
                                    setState(() {
                                      textControllerDate.clear();
                                    }),
                                  },
                                  controller: textControllerDate,
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
                                      firstDate: selectedDate ?? DateTime.now(),
                                      lastDate: DateTime(2022),
                                      initialDate:
                                          selectedDate ?? DateTime.now(),
                                    );
                                    // print(DateFormat('yyyy/MM/dd').format(date));
                                    // if (date != null)
                                    selectedDate = date;
                                    if (date != null) {
                                      this.date = DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                      final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue ?? DateTime.now()),
                                          builder: (context, child) =>
                                              Localizations.override(
                                                context: context,
                                                locale: Locale('he'),
                                                child: child,
                                              ));

                                      selectedStartTime = DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          time.hour,
                                          time.minute);

                                      return DateTimeField.combine(
                                          selectedDate, time);
                                    } else {
                                      return DateTime.now();
                                    }
                                  },
                                  readOnly: true,
                                ),
                              ),
                              isEditingDate
                                  ? Text(
                                      testDateTime(
                                          selectedDate, selectedStartTime),
                                      style: TextStyle(
                                          color: Colors.red,
                                          decoration: TextDecoration.none),
                                    )
                                  : SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  text: 'משך שיחה',
                                  style: TextStyle(
                                    color: CustomColor.dark_cyan,
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: isWeb
                                    ? EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                5)
                                    : EdgeInsets.only(left: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: lengthDrop,
                                    icon: Icon(Icons.arrow_circle_up_outlined),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        if (newValue != null) {
                                          lengthDrop = newValue;
                                          callLength = newValue;
                                          isEditingLength = true;
                                        } else {
                                          callLength = lengthDrop;
                                        }
                                      });
                                    },
                                    items: <String>[
                                      '30' + ' דקות ',
                                      '60' + ' דקות ',
                                      'בחר/י'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.end,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              lengthDrop == 'בחר/י' && isEditingLength
                                  ? Text(
                                      'אנא הזנ/י משך שיחה',
                                      style: TextStyle(
                                          color: Colors.red,
                                          decoration: TextDecoration.none),
                                    )
                                  : SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  text: 'כותרת',
                                  style: TextStyle(
                                    color: CustomColor.dark_cyan,
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: isWeb
                                    ? EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                5)
                                    : EdgeInsets.only(left: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: descDrop,
                                    icon: Icon(Icons.arrow_circle_up_outlined),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        if (newValue != null) {
                                          descDrop = newValue;
                                          currentDesc = descDrop;
                                          isEditingDesc = true;
                                        } else {
                                          callDesc = currentDesc;
                                        }
                                      });
                                    },
                                    items: StaticObjects.descAutoFill
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.end,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              descDrop == 'בחר/י כותרת לפגישה' && isEditingDesc
                                  ? Text(
                                      'אנא הכנס/י תיאור לשיחה',
                                      style: TextStyle(
                                          color: Colors.red,
                                          decoration: TextDecoration.none),
                                    )
                                  : SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  text: 'תיאור',
                                  style: TextStyle(
                                    color: CustomColor.dark_cyan,
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' ',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: isWeb
                                    ? EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                5)
                                    : EdgeInsets.only(left: 10),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  enabled: true,
                                  cursorColor: CustomColor.sea_blue,
                                  focusNode: textFocusNodeTitle,
                                  controller: textControllerTitle,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    setState(() {
                                      isEditingTitle = true;
                                      currentTitle = value;
                                    });
                                  },
                                  onSubmitted: (value) {
                                    textFocusNodeTitle.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(textFocusNodeDesc);
                                  },
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                  decoration: new InputDecoration(
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: CustomColor.sea_blue,
                                          width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: CustomColor.dark_blue,
                                          width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.redAccent, width: 2),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: 16,
                                      bottom: 16,
                                      top: 16,
                                      right: 16,
                                    ),
                                    hintText: 'דוגמא: תרגום לשיחה עם בנקאי',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    errorText: isEditingTitle
                                        ? _validateTitle(currentTitle)
                                        : null,
                                    errorStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xff9AB7D0),
                                          Color(0xff004E98),
                                          Color(0xff0F122A)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)),
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 4,
                                    vertical: 15),
                                child: InkWell(
                                  onTap: isDataStorageInProgress
                                      ? () {}
                                      : () async {
                                          setState(() {
                                            isErrorTime = false;
                                            isDataStorageInProgress = true;
                                          });

                                          textFocusNodeTitle.unfocus();
                                          textFocusNodeDesc.unfocus();
                                          textFocusNodeLocation.unfocus();
                                          textFocusNodeAttendee.unfocus();

                                          if (testDateTime(selectedDate,
                                                      selectedStartTime) ==
                                                  '' &&
                                              currentTitle != null &&
                                              callLength != 'בחר/י' &&
                                              currentDesc != null &&
                                              callDesc !=
                                                  'בחר/י כותרת לפגישה') {
                                            int startTimeInEpoch = DateTime(
                                              selectedDate.year,
                                              selectedDate.month,
                                              selectedDate.day,
                                              selectedStartTime.hour,
                                              selectedStartTime.minute,
                                            ).millisecondsSinceEpoch;

                                            print(
                                                'Start Time: ${DateFormat('yyyy/MM/dd - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(startTimeInEpoch))}');

                                            //Todo: make sure start time is after NOW
                                            if (_validateTitle(currentTitle) ==
                                                null) {
                                              calendar.EventAttendee
                                                  eventAttendee =
                                                  calendar.EventAttendee();

                                              eventAttendee.email = userMail;

                                              attendeeEmails.add(eventAttendee);

                                              List<String> emails = [];

                                              for (int i = 0;
                                                  i < attendeeEmails.length;
                                                  i++)
                                                emails.add(
                                                    attendeeEmails[i].email);

                                              var endTime = selectedStartTime;

                                              var uuid = Uuid();
                                              if (callLength.contains('3')) {
                                                if (selectedStartTime.minute <
                                                    30) {
                                                  endTime = DateTime(
                                                      selectedDate.year,
                                                      selectedDate.month,
                                                      selectedDate.day,
                                                      selectedStartTime.hour,
                                                      selectedStartTime.minute +
                                                          30);
                                                } else {
                                                  endTime = DateTime(
                                                      selectedDate.year,
                                                      selectedDate.month,
                                                      selectedDate.day,
                                                      selectedStartTime.hour +
                                                          1,
                                                      selectedStartTime.minute -
                                                          30);
                                                }
                                              } else {
                                                if (callLength.contains('6')) {
                                                  if (selectedStartTime.hour <
                                                      23)
                                                    endTime = DateTime(
                                                        selectedDate.year,
                                                        selectedDate.month,
                                                        selectedDate.day,
                                                        selectedStartTime.hour +
                                                            1,
                                                        selectedStartTime
                                                            .minute);
                                                  else {
                                                    endTime = DateTime(
                                                        selectedDate.year,
                                                        selectedDate.month,
                                                        selectedDate.day + 1,
                                                        selectedStartTime.hour -
                                                            23,
                                                        selectedStartTime
                                                            .minute);
                                                  }
                                                }
                                              }

                                              EventInfo eventInfo = EventInfo(
                                                  date: DateTimeField.combine(
                                                          selectedDate,
                                                          TimeOfDay.fromDateTime(
                                                              selectedStartTime))
                                                      .toString(),
                                                  occupied: false,
                                                  id: uuid.v4(),
                                                  customerId: userId,
                                                  interId: '',
                                                  title: currentDesc,
                                                  description:
                                                      currentTitle ?? '',
                                                  email: userMail,
                                                  startTimeInEpoch:
                                                      startTimeInEpoch,
                                                  endTimeInEpoch: endTime
                                                      .millisecondsSinceEpoch,
                                                  length:
                                                      (callLength.contains('3'))
                                                          ? 30
                                                          : 60,
                                                  state: 'pending',
                                                  answer: false,
                                                  creationTime: DateTime.now());

                                              HttpsCallable createEvent =
                                                  FirebaseConstFunctions
                                                      .createEvent;
                                              final eventLeft =
                                                  await createEvent
                                                      .call(eventInfo.toJson())
                                                      .catchError(
                                                          (e) => print(e));
                                              if (eventLeft.data)
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (con) =>
                                                                TabbedPage(
                                                                  uid: _auth
                                                                      .currentUser
                                                                      .uid,
                                                                  role:
                                                                      'customer',
                                                                  initialIndex:
                                                                      2,
                                                                )));
                                              else {
                                                AlertDialog(
                                                  content: Text(
                                                      'אין לך מספיק קרדיט לשיחה הזו'),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('אישור'),
                                                    )
                                                  ],
                                                );
                                              }

                                              setState(() {
                                                isDataStorageInProgress = false;
                                              });
                                            } else {
                                              setState(() {
                                                isEditingTitle = true;
                                                // isEditingLink = true;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              isEditingDate = true;
                                              isEditingStartTime = true;
                                              isEditingBatch = true;
                                              isEditingTitle = true;
                                              isEditingLength = true;
                                              // isEditingLink = true;
                                            });
                                          }
                                          setState(() {
                                            isDataStorageInProgress = false;
                                          });
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: isDataStorageInProgress
                                        ? SizedBox(
                                            height: 28,
                                            width: 28,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                            ),
                                          )
                                        : Text(
                                            'קבע/י',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: isWeb ? 22 : 12,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // ],
                        ),
                      ),
                      // SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'Add video conferencing',
                      //       style: TextStyle(
                      //         color: CustomColor.dark_cyan,
                      //         fontFamily: 'Raleway',
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //         letterSpacing: 0.5,
                      //       ),
                      //     ),
                      //     Switch(
                      //       value: hasConferenceSupport,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           hasConferenceSupport = value;
                      //         });
                      //       },
                      //       activeColor: CustomColor.sea_blue,
                      //     ),
                      // ],
                    ),
                    Visibility(
                      visible: isErrorTime,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorString,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                )
              : isOnDemand
                  ? Column(
                      children: [
                        Text(
                          Strings.onDemandEnterNameAndTitle,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'alef'),
                        ),
                        Center(
                          child: Container(
                            height: isWeb ? pageHeight / 2 : pageHeight - 10,
                            margin: EdgeInsets.symmetric(
                                horizontal: isWeb ? pageWidth / 10 : 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white.withOpacity(0.7),
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
                                Column(
                                  children: [
                                    Text(
                                      Strings.onDemandTextEnterName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          isEditing = true;
                                        });

                                        didChangeName = true;
                                        name = value;
                                      },
                                      onEditingComplete: () =>
                                          isEditing = false,
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: Strings.onDemandHintEnterName,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    didChangeName
                                        ? SizedBox(
                                            height: 5,
                                          )
                                        : Text(
                                            'אנא הזינו שם',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                    Text(
                                      'הזינו תיאור לשיחה ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          isEditing = true;
                                        });
                                        didChangeTitle = true;
                                        title = value;
                                      },
                                      onEditingComplete: () =>
                                          isEditing = false,
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        hintText: 'תיאור השיחה ',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    didChangeTitle
                                        ? SizedBox(
                                            height: 5,
                                          )
                                        : Text(
                                            'אנא הזינו תיאור לפגישה',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                    SizedBox(height: 10),
                                    RaisedButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      child: inProgress
                                          ? CircularProgressIndicator()
                                          : Text('הזמנה'),
                                      onPressed: inProgress
                                          ? () {}
                                          : () {
                                              setState(() {
                                                inProgress = true;
                                                if (nameController.text != '' &&
                                                    name != '')
                                                  nameTitle['name'] = name;
                                                else {
                                                  didChangeName = false;
                                                }
                                                if (titleController.text !=
                                                        '' &&
                                                    title != '')
                                                  nameTitle['title'] = title;
                                                else {
                                                  didChangeTitle = false;
                                                }
                                                if (nameTitle['name'] != null &&
                                                    nameTitle['title'] !=
                                                        null) {
                                                  final uuid = Uuid();
                                                  ODMEvent event = ODMEvent(
                                                      title: nameTitle['title'],
                                                      customerName:
                                                          nameTitle['name'],
                                                      link:
                                                          'https://signowvideo.web.app/?roomName=${uuid.v1().substring(0, 8)}');
                                                  final createODMEvent =
                                                      FirebaseConstFunctions
                                                          .createODMEvent;

                                                  createODMEvent
                                                      .call(event.toJson())
                                                      .whenComplete(() => Navigator
                                                          .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (con) =>
                                                                      WaitingRoom(
                                                                        event:
                                                                            event,
                                                                      ))));
                                                }
                                              });
                                            },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
    );
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
