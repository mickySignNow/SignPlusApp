// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;
//
// import 'package:easy_web_view/easy_web_view.dart';
// import 'package:sign_plus/url_launcher/web.dart';
// import 'package:sign_plus/utils/style.dart';
//
// void main() {
//   runApp(VideoCallWeb());
// }
//
// class VideoCallWeb extends StatefulWidget {
//   VideoCallWeb({Key key}) : super(key: key);
//
//   @override
//   _VideoCallWebState createState() => _VideoCallWebState();
// }
//
// class _VideoCallWebState extends State<VideoCallWeb> {
//   _VideoCallWebState({Key key});
//
//   InAppWebViewController _webViewController;
//
//   @override
//   void initState() {
//     try {
//       UrlUtils.open('https://meet.jit.si/signnow1');
//     } catch (e) {
//       print(e);
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildNavBar(context, ''),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Center(
//             child: Container(child: Image.asset('images/Sign+ logo.png')),
//           )
//         ],
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
