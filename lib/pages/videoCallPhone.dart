// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:sign_plus/utils/style.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: VideoCallPhone(),
//     );
//   }
// }
//
// class VideoCallPhone extends StatefulWidget {
//   VideoCallPhone({Key key}) : super(key: key);
//
//   @override
//   _VideoCallPhoneState createState() => _VideoCallPhoneState();
// }
//
// class _VideoCallPhoneState extends State<VideoCallPhone> {
//   InAppWebViewController _webViewController;
//
//   Future isPhone() async {
//     if (!kIsWeb) {
//       if (Platform.isAndroid) {
//         WidgetsFlutterBinding.ensureInitialized();
//         await Permission.camera.request();
//         await Permission.microphone.request();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     isPhone();
//     return Scaffold(
//       appBar: buildNavBar(context, ''),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Flexible(
//             child: Container(
//                 child: InAppWebView(
//                     initialUrl: 'https://meet.jit.si/signnow1',
//                     initialOptions: InAppWebViewGroupOptions(
//                       crossPlatform: InAppWebViewOptions(
//                         mediaPlaybackRequiresUserGesture: false,
//                         debuggingEnabled: true,
//                       ),
//                     ),
//                     onWebViewCreated: (InAppWebViewController controller) {
//                       _webViewController = controller;
//                     },
//                     androidOnPermissionRequest:
//                         (InAppWebViewController controller, String origin,
//                             List<String> resources) async {
//                       return PermissionRequestResponse(
//                           resources: resources,
//                           action: PermissionRequestResponseAction.GRANT);
//                     })),
//           )
//         ],
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
