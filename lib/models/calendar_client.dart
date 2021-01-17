import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';

class CalendarClient {
  static var calendar;

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
    @required List<EventAttendee> attendeeEmailList,
    @required bool shouldNotifyAttendees,
    @required bool hasConferenceSupport,
    @required DateTime startTime,
    @required DateTime endTime,
  }) async {
    Map<String, String> eventData;

    String calendarId = "primary";
    Event event = Event();
    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = 'https://signplus-295808.web.app/';

    // ConferenceData conferenceData = ConferenceData();
    //
    // CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
    // conferenceRequest.requestId =
    //     "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
    // print('CALENDAR CLIENT 32 req id: ' + conferenceRequest.requestId);
    // conferenceData.createRequest = conferenceRequest;
    // print('CALENDAR CLIENT 34  createRequest:' + conferenceData.toString());
    //
    // event.conferenceData = conferenceData;

    EventDateTime start = new EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+02:00";
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.timeZone = "GMT+02:00";
    end.dateTime = endTime;
    event.end = end;

    try {
      print(calendar);

      /// calendar was init when user authenticated
      /// insert here refers to the calendar ^ and will insert the event to the calendar connected
      await calendar.events
          .insert(event, calendarId,
              conferenceDataVersion: 1, sendUpdates: "all")
          .then((value) {
        print("Event Status: ${value.status}");
        if (value.status == "confirmed") {
          String joiningLink;
          String eventId;

          eventId = value.id;

          joiningLink =
              "https://signowvideo.web.app/?roomName=${DateFormat('dd-MM-yy').format(startTime)}$title}";

          event.location = joiningLink;
          eventData = {
            'id': eventId,
            'link': joiningLink,
            'location': joiningLink
          };

          print('Event added to Google Calendar');
        } else {
          print("Unable to add event to Google Calendar");
        }
      });
    } catch (e) {
      print('Error creating event $e');
    }
    print(event.attendees);
    print(event);
    print(eventData);
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
        print("Event Status: ${value.status}");
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
