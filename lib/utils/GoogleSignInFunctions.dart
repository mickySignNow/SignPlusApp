import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:sign_plus/models/calendar_client.dart';
import 'package:sign_plus/pages/tabbedPage.dart';
import 'package:sign_plus/utils/secrets.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/auth_browser.dart' as auth;

class GoogleSignInFunctions {
  static void googleSignIn(
    FirebaseAuth _auth,
    BuildContext context,
  ) async {
    // Trigger the authentication flow
    /// _clientID - the client of the app from google cloud platform
    var _clientID = new ClientId(Secret.getId(), "ku6x0zAKIbXvU7X_Kx9nY8_T");

    /// _scopes - persmissions for using the user's Calendar
    const _scopes = const [cal.CalendarApi.CalendarScope];

    final GoogleSignInAccount googleUser = await GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/userinfo.email']).signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    //
    // // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    /// sign in to firebase authentication
    final userCredential = await _auth.signInWithCredential(credential);
    final User user = userCredential.user;

    if (user != null) {
      HttpsCallable getRoleById =
          FirebaseFunctions.instance.httpsCallable("checkRoleUser");
      var userKind = await getRoleById.call({'uid': user.uid});

      if (userKind.data == 'user')
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (con) => TabbedPage(uid: user.uid, role: 'customer')));
      else {
        print('inter logging in');

        ///  auth.createImplicitBrowswerFlow - a method that creates a login flow via browser
        ///  the method return a browser auth connection.
        ///  we use then function to use the flow we got from method above
        ///  flow.clientViaUserConsest - a authentication method that returns an AuthClient, to use for Calendar API
        try {
          await auth
              .createImplicitBrowserFlow(_clientID, _scopes)
              .then((auth.BrowserOAuth2Flow flow) {
            flow.clientViaUserConsent().then((auth.AuthClient client) async {
              print(client.credentials.idToken ?? 'No Client');
              CalendarClient.calendar = cal.CalendarApi(client);

              String adminPanelCalendarId = 'primary';

              var event = CalendarClient.calendar.events;

              var events = event.list(adminPanelCalendarId);

              // events.then((showEvents) {
              //   showEvents.items.forEach((cal.Event ev) {
              //     print(ev.summary);
              //     print(ev.status);
              //   });
              // });

              /// second sign in for connecting to firebase, silently
              GoogleSignInAccount googleUser =
                  await GoogleSignIn().signInSilently();
              // await GoogleSignIn(
              //         scopes: ['https://www.googleapis.com/auth/userinfo.email'])
              //     .signIn();
              // Obtain the auth details from the request

              if (googleUser == null) {
                googleUser = await GoogleSignIn().signIn();
              }
              final GoogleSignInAuthentication googleAuth =
                  await googleUser.authentication;
              //
              // // Create a new credential
              final GoogleAuthCredential credential =
                  GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );

              /// sign in to firebase authentication
              final userCredential =
                  await _auth.signInWithCredential(credential);
              final User user = userCredential.user;
              if (user != null) {
                HttpsCallable getRoleById =
                    FirebaseFunctions.instance.httpsCallable('CheckUserRole');
                var res =
                    await getRoleById.call({'uid': _auth.currentUser.uid});
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (con) => TabbedPage(
                              role: res.data,
                              uid: _auth.currentUser.uid,
                            )));
              }
            });
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }
}
