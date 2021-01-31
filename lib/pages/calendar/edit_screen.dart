import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/models/event_info.dart';
import 'package:sign_plus/resources/color.dart';
import 'package:sign_plus/models/storage.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';
import 'package:sign_plus/utils/Functions.dart';
import 'package:sign_plus/utils/StaticObjects.dart';

class EditScreen extends StatefulWidget {
  final EventInfo event;

  EditScreen({this.event});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Storage storage = Storage();
  CalendarClient calendarClient = CalendarClient();

  TextEditingController textControllerDate;
  TextEditingController textControllerStartTime;
  TextEditingController textControllerEndTime;
  TextEditingController textControllerTitle;
  TextEditingController textControllerDesc;
  TextEditingController textControllerLocation;
  TextEditingController textControllerAttendee;

  FocusNode textFocusNodeTitle;
  FocusNode textFocusNodeDesc;
  FocusNode textFocusNodeLocation;
  FocusNode textFocusNodeAttendee;

  DateTime selectedDate = DateTime.now();
  DateTime selectedStartTime = DateTime.now();

  String date;
  String eventId;
  String currentTitle;
  String currentDesc;
  String currentLocation;
  String currentEmail;
  String errorString = '';
  String callLength = '';
  String callDesc = '';
  String lengthDrop = 'בחר/י';
  String descDrop = 'בחר/י כותרת לפגישה';
  List<calendar.EventAttendee> attendeeEmails = [];

  bool isEditingDate = false;
  bool isEditingStartTime = false;
  bool isEditingLength = false;
  bool isEditingDesc = false;
  bool isEditingTitle = false;
  bool isEditingEmail = false;
  bool isEditingLink = false;
  bool isErrorTime = false;
  bool shouldNofityAttendees = false;
  bool hasConferenceSupport = false;

  bool dateWasEdited = false;
  bool lengthWasEdited = false;
  bool titleWasEdited = false;
  bool descWasEdited = false;

  bool isDataStorageInProgress = false;
  bool isDeletionInProgress = false;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textControllerDate.text = DateFormat.yMMMMd().format(selectedDate);
      });
    }
  }

  String _validateTitle(String value) {
    if (value != null) {
      value = value?.trim();
      if (value.isEmpty) {
        return 'Title can\'t be empty';
      }
    } else {
      return 'Title can\'t be empty';
    }

    return null;
  }

  String _validateEmail(String value) {
    if (value != null) {
      value = value.trim();

      if (value.isEmpty) {
        return 'Can\'t add an empty email';
      } else {
        final regex = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        final matches = regex.allMatches(value);
        for (Match match in matches) {
          if (match.start == 0 && match.end == value.length) {
            return null;
          }
        }
      }
    } else {
      return 'Can\'t add an empty email';
    }

    return 'Invalid email';
  }

  @override
  void initState() {
    DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(widget.event.startTimeInEpoch);
    DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(widget.event.endTimeInEpoch);

    selectedStartTime = startTime;
    currentTitle = widget.event.title;
    currentDesc = widget.event.description;
    // currentLocation = widget.event.location;
    eventId = widget.event.id;
    // hasConferenceSupport = widget.event.hasConfereningSupport;

    // widget.event.attendeeEmails.forEach((element) {
    //   calendar.EventAttendee eventAttendee = calendar.EventAttendee();
    //   eventAttendee.email = element;
    //
    //   attendeeEmails.add(eventAttendee);
    // });

    String dateString = DateFormat.yMMMMd().format(startTime);
    String startString = DateFormat.jm().format(startTime);
    String endString = DateFormat.jm().format(endTime);

    textControllerDate = TextEditingController(text: dateString);
    textControllerStartTime = TextEditingController(text: startString);
    textControllerTitle = TextEditingController(text: widget.event.title);
    textControllerDesc = TextEditingController(text: currentDesc);
    textControllerLocation = TextEditingController(text: currentLocation);
    textControllerAttendee = TextEditingController();

    textFocusNodeTitle = FocusNode();
    textFocusNodeDesc = FocusNode();
    textFocusNodeLocation = FocusNode();
    textFocusNodeAttendee = FocusNode();

    super.initState();
  }

  updateEvent() async {
    await FirebaseConstFunctions.updateEvent.call({
      "eventID": "97c2f66a-7ed2-43de-9e11-659d4d4f22b8",
      "updatedValues": [
        {"key": "length", "value": 30},
        {"key": "customerName", "value": "changed"}
      ]
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    bool isWeb = (pageWidth > 700);

    updateEvent();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: Text(
          'Edit Event',
          style: TextStyle(
            color: CustomColor.dark_blue,
            fontSize: 22,
          ),
        ),
        actions: [
          FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: isDeletionInProgress
                ? null
                : () async {
                    setState(() {
                      isDeletionInProgress = true;
                      isDataStorageInProgress = true;
                    });
                    await calendarClient
                        .delete(eventId, true)
                        .whenComplete(() async {
                      await storage
                          .deleteEvent(id: eventId)
                          .whenComplete(() => Navigator.of(context).pop())
                          .catchError((e) => print(e));
                    });

                    setState(() {
                      isDeletionInProgress = false;
                      isDataStorageInProgress = false;
                    });
                  },
            color: Colors.white,
            child: isDeletionInProgress
                ? SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : Text(
                    'DELETE',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'הזינו את הפרטים כאן ומתורגמ/נית זמי/נה ת/יפגש איתכם',
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
                    Row(
                      children: [
                        Container(
                          margin: (isWeb)
                              ? EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 5)
                              : EdgeInsets.only(left: 10),
                          child: DateTimeField(
                            decoration: InputDecoration(
                              hintText: 'הזנ/י תאריך ושעה רצויים',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: CustomColor.sea_blue, width: 1),
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
                                initialDate: selectedDate ?? DateTime.now(),
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
                      ],
                    ),
                    isEditingDate
                        ? Text(
                            testDateTime(selectedDate, selectedStartTime),
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
                              horizontal: MediaQuery.of(context).size.width / 5)
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
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
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
                              horizontal: MediaQuery.of(context).size.width / 5)
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
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
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
                              horizontal: MediaQuery.of(context).size.width / 5)
                          : EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              textAlign: TextAlign.center,
                              enabled: true,
                              cursorColor: CustomColor.sea_blue,
                              focusNode: textFocusNodeTitle,
                              controller: textControllerTitle,
                              textCapitalization: TextCapitalization.sentences,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: CustomColor.sea_blue, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: CustomColor.dark_blue, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.redAccent, width: 2),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
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
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                isEditingTitle = !isEditingTitle;
                              });
                            },
                            child: Text(isEditingTitle ? 'בעריכה' : 'ערוך'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.maxFinite,
                      child: RaisedButton(
                        elevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        color: CustomColor.sea_blue,
                        onPressed: isDataStorageInProgress
                            ? null
                            : () async {
                                setState(() {
                                  isErrorTime = false;
                                  isDataStorageInProgress = true;
                                });

                                textFocusNodeTitle.unfocus();
                                textFocusNodeDesc.unfocus();
                                textFocusNodeLocation.unfocus();
                                textFocusNodeAttendee.unfocus();

                                if (selectedDate != null &&
                                    selectedStartTime != null &&
                                    currentTitle != null) {
                                  int startTimeInEpoch = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedStartTime.hour,
                                    selectedStartTime.minute,
                                  ).millisecondsSinceEpoch;

                                  int endTimeInEpoch = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                  ).millisecondsSinceEpoch;

                                  if (endTimeInEpoch - startTimeInEpoch > 0) {
                                    if (_validateTitle(currentTitle) == null) {
                                      await calendarClient
                                          .modify(
                                              id: eventId,
                                              title: currentTitle,
                                              description: currentDesc ?? '',
                                              location: currentLocation,
                                              attendeeEmailList: attendeeEmails,
                                              // shouldNotifyAttendees:
                                              //     shouldNofityAttendees,
                                              // hasConferenceSupport:
                                              //     hasConferenceSupport,
                                              startTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      startTimeInEpoch),
                                              endTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      endTimeInEpoch))
                                          .then((eventData) async {
                                        String eventId = eventData['id'];
                                        String eventLink = eventData['link'];

                                        List<String> emails = [];

                                        for (int i = 0;
                                            i < attendeeEmails.length;
                                            i++)
                                          emails.add(attendeeEmails[i].email);

                                        EventInfo eventInfo = EventInfo(
                                          id: eventId,
                                          title: currentTitle,
                                          description: currentDesc ?? '',
                                          // location: currentLocation,
                                          link: eventLink,
                                          // TODO: change email to interpreters email
                                          email: 'mickykroapps@gmail.com',
                                          // shouldNotifyAttendees:
                                          //     shouldNofityAttendees,
                                          // hasConfereningSupport:
                                          //     hasConferenceSupport,
                                          startTimeInEpoch: startTimeInEpoch,
                                          endTimeInEpoch: endTimeInEpoch,
                                        );

                                        await storage
                                            .updateEventData(
                                                eventInfo,
                                                FirebaseAuth
                                                    .instance.currentUser.uid)
                                            .whenComplete(() =>
                                                Navigator.of(context).pop())
                                            .catchError(
                                              (e) => print(e),
                                            );
                                      }).catchError(
                                        (e) => print(e),
                                      );

                                      setState(() {
                                        isDataStorageInProgress = false;
                                      });
                                    } else {
                                      setState(() {
                                        isEditingTitle = true;
                                        isEditingLink = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isErrorTime = true;
                                      errorString =
                                          'Invalid time! Please use a proper start and end time';
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isEditingDate = true;
                                    isEditingStartTime = true;

                                    isEditingTitle = true;
                                    isEditingLink = true;
                                  });
                                }
                                setState(() {
                                  isDataStorageInProgress = false;
                                });
                              },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: isDataStorageInProgress
                              ? SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                )
                              : Text(
                                  'MODIFY',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
