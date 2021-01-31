import 'dart:html';

import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart';

import '../models/calendar_client.dart';
import '../models/calendar_client.dart';
import '../models/calendar_client.dart';
import '../models/calendar_client.dart';

class GoogleServiceAccount {
  static final _credentials = ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "signplus-295808",
    "private_key_id": "c8e163680bac1c8649bae83117435f1317084a48",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCbEx3akEmOO+iV\nbJikPR8JvyXI6hM8B9gk/tO6rs/8nLD4aVxBgVmqpfT45TI+iR/ak3wlWLPjtJ/t\nd0xAMK6ulDriDAmuR1ELHfgHN/RKKvEWLicRMz/cNlgOF3cjGepeP/Dj8sxitYzR\n4qizhknm0WJwjLFCO32dwJsg1qi+3vrNPINASsn2B4IIjK+6MCznVCHp0Vjl8Cec\nhEnwDTP8D7cPUFlvVnSnzCR516ZWDxgTdwTGXCRIHETTEFSwQzqZPoKfgVGWNxIQ\nBEPTmVmK4OfhVpkc0pj05u9LuEMn5EMOGzBod9JR/0ro1ysYPe1yYA5s803i9Vny\nAp47qX4xAgMBAAECggEAC/us76X9LRrHhP5siCp58saczJr77AReKTOw2EjoZQiV\nq0h2+s/cRjHHTZFmccsmVT1W10r0saiUQCUbFQ29/dsR9sQ/3kIACvggoawq+i05\nzoE3/x4C9gkUAljBWcrHn8tYmcC6FvmY/WICr8a1gLrW3MQecXQH57AJvL6hsQgK\nsyCOmDdtKY27JCKV95KrAPPkfDQx/BknXa4UtyOUxphISBetDaZHnnblf2XhD45M\nbmedIl6vnI9RfIq7ZJK0MygDHSkWl2VtWSK8VO6D6AMTodG0RH6kown9XgY0IyOH\nMN6VNG68iORPuWPvQUSXkgUIqNN19I/SGm8aGGdo3QKBgQDMgOTjC6DoAHDjoITk\n1gUOHw6CMANS99sff2pCBAwCTDIHN1EDkM+86Zmc8bmz5kHRKpQ3UlXo1OnxRjoY\n0cWFhvzwbd99opsVwVgDDkWQdfqaryAXxXpdK7bPFetep9iMxCkvt+ziujESxLxL\nO1oVXGc9MeKgoYvP41fhGCLVFQKBgQDCH9hNp9q1NegSKTXGj6qkeC4YiVSXbLD7\nSEMFHixxvPShYUgomPbzjpp2iCk/Q5cJewzbyPvBr9XaytAyRj2r4NHahdbES10q\nEJ4znoZhywieNV4yEWzgcdfU46o7ar422ADi04BVqROH3Ir2ctsH/UXVn4C1I+by\nUTtC0a9DrQKBgQCI69fT6EpAa2MqFKRFrsHNtZ96LPlcyJROn3meX6VGuItaZ3/3\nejKMkn8GJJYoTAdPK0n3TEo2zK8hmtp1GaY9A6dAtt/G92MMitoJmbmbwlIa1RwQ\nrmiCDy2js1JWmtyTSxckWung17bZkR1c5Y0n9iktQMQytlasxtNk40sXDQKBgQCn\nwNExOk6brfvgRdB8yIYUHu7msTZyrLC8VZPlBlAt8bYNB35N5vHxQ1hj+gJ68zPA\nM5/HBoXYuNS7f+wupdiBgYSXrHUNqHrX8QhlXyaNt+C4pzHBXqGRy49SH3NqaTH7\nPup1GYSbgcKo84L6ugJhgxMoKfAVmPLokB3//ifQ+QKBgQCmxlkWa7BzoAs1frcQ\nzrLnFPpT3Pq9y9bNGMCQ5RpuBwUWC/2Z1obCJXZx7AMpr+yVggQhDs+GMifINRiK\n0fo8aOVtfFHHhX0opOOo8/TPiV3L1OgtTLPY+o2sxSHHKoxvoe11jpbvEk/4Tpgd\n+mxf0mNy+GwqF4THpJ82K92o6w==\n-----END PRIVATE KEY-----\n",
    "client_email": "signplusbot@signplus-295808.iam.gserviceaccount.com",
    "client_id": "103457469795116904451",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/signplusbot%40signplus-295808.iam.gserviceaccount.com"
            ''
  }, impersonatedUser: 'info@signow.org');

  static final _SCOPES = const [
    CalendarApi.CalendarScope,
  ];

  static getClient() async {
    print(_credentials);
    final client =
        await clientViaServiceAccount(_credentials, _SCOPES).then((client) {
      print(client.credentials.accessToken);
      print(client.credentials.idToken);
      CalendarClient.calendar = CalendarApi(client);

      String adminPanelCalendarId = 'primary';

      var event = CalendarClient.calendar.events;

      var events = event.list(adminPanelCalendarId);

      events.then((showEvents) {
        showEvents.items.forEach((Event ev) {
          print(ev.summary);
          print(ev.status);
        });
      });
    });
  }
}
