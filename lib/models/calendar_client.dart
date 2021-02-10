import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CalendarClient {
  static var calendar;

  var uuid = Uuid();

  /**
   * a function to add an Event to Calendar
   * @params :
   * title - title of event
   * description -  optional desription of event
   * attendeeList - Google event requires a List, we are going to fill the list with only one email
   * shouldNotifyAttendees - always true
   * hasConferenceSupport - always true
   * startTime - event start time
   * endTime - event end time
   *
   * in the method we create a new instance of event and fill it with params we got
   *
   * */
  Future<Map<String, String>> insert({
    @required String title,
    String description,
    @required String customerName,
    @required String interName,
    @required List<EventAttendee> attendeeEmailList,
    @required bool shouldNotifyAttendees,
    @required bool hasConferenceSupport,
    @required DateTime startTime,
    @required DateTime endTime,
  }) async {
    Map<String, String> eventData;

    var eventRoomId = uuid.v1();
    String calendarId = "primary";
    Event event = Event();
    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = 'https://signplus-295808.web.app/';
    String joiningLink = "https://signowvideo.web.app/?roomName=$eventRoomId";

    print(interName);
    print(customerName);
    print('got here');

    String interFirstName = 'מתורגמנית';
    List<String> customerFirstName = customerName.split('/(\s+\)/');
    print(interFirstName);
    print(customerFirstName);
    event.description = "Signow מברכת אתכם" +
        '\n' +
        'לכניסה לפגישה כנסי לקישור המתאים לך לפי השם:' +
        '\n' +
        '$interName: ' +
        '\n' +
        '$joiningLink&name=$interFirstName&exitUrl=https://forms.gle/ZUNRJWgkvCckxaoR6' +
        '\n ' +
        '$customerName: ' +
        '\n' +
        '$joiningLink&name=${customerFirstName.first}&exitUrl=https://forms.gle/zq2Rk9ihL1Gdeoxg9';

    EventDateTime start = new EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+02:00";
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.timeZone = "GMT+02:00";
    end.dateTime = endTime;
    event.end = end;

    event.attendees.first.comment = joiningLink +
        '&name=$customerName&exitUrl=https://forms.gle/zq2Rk9ihL1Gdeoxg9';

    event.attendees.last.comment = joiningLink +
        '&name=$interName&exitUrl=https://forms.gle/ZUNRJWgkvCckxaoR6';

    try {
      /// calendar was init when user authenticated
      /// insert here refers to the calendar ^ and will insert the event to the calendar connected
      print('entered try');
      await calendar.events
          .insert(event, calendarId,
              conferenceDataVersion: 1, sendUpdates: "all")
          .then((value) {
        print('entered insert');
        // if (value.status == "confirmed") {
        String eventId;
        eventId = value.id;

        eventData = {
          'id': eventId,
          'link': joiningLink,
          'location': joiningLink
        };
        // } else {
        //   // print("Unable to add event to Google Calendar");
        // }
      });
    } catch (e) {
      print('Error creating event $e');
    }

    return eventData;
  }

  Future<Map<String, String>> modify({
    @required String id,
    @required String title,
    @required String description,
    @required String location,
    @required List<EventAttendee> attendeeEmailList,
    @required bool shouldNotifyAttendees,
    @required bool hasConferenceSupport,
    @required DateTime startTime,
    @required DateTime endTime,
  }) async {
    Map<String, String> eventData;

    print(attendeeEmailList.first.email);
    print(attendeeEmailList.last.email);

    // If the account has multiple calendars, then select the "primary" one
    String calendarId = "primary";
    Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    ConferenceData conferenceData = ConferenceData();
    CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
    conferenceRequest.requestId =
        "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
    conferenceData.createRequest = conferenceRequest;

    event.conferenceData = conferenceData;

    EventDateTime start = new EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    try {
      await calendar.events
          .insert(event, calendarId,
              conferenceDataVersion: hasConferenceSupport ? 1 : 0,
              sendUpdates: shouldNotifyAttendees ? "all" : "none")
          .then((value) {
        if (value.status == "confirmed") {
          String joiningLink;
          String eventId;

          eventId = value.id;

          joiningLink =
              "https://meet.google.com/${value.conferenceData.conferenceId}";

          eventData = {'id': eventId, 'link': joiningLink};

          print('Event added to Google Calendar');
        } else {
          print("Unable to add event to Google Calendar");
        }
      });
    } catch (e) {
      print('Error creating event $e');
    }

    return eventData;
  }

  Future<void> delete(String eventId, bool shouldNotify) async {
    String calendarId = "primary";

    try {
      await calendar.events
          .delete(calendarId, eventId,
              sendUpdates: shouldNotify ? "all" : "none")
          .then((value) {
        print('Event deleted from Google Calendar');
      });
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
