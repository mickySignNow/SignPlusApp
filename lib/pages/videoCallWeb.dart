import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_web_ui/ui.dart' as uiWeb;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sign_plus/url_launcher/web.dart';
import 'package:sign_plus/utils/style.dart';

void main() {
  runApp(VideoCallWeb());
}

class VideoCallWeb extends StatefulWidget {
  VideoCallWeb({Key key}) : super(key: key);

  @override
  _VideoCallWebState createState() => _VideoCallWebState();
}

class _VideoCallWebState extends State<VideoCallWeb> {
  _VideoCallWebState({Key key});

  WebViewController _controller;
  String videoUrl =
      'https://signowvideo.web.app/?roomName=ODMSignNow&name=מתורגמן&exitUrl=https://forms.gle/ZUNRJWgkvCckxaoR6';

  @override
  void initState() {
    // PlatformViewRegistry.registerViewFactory(
    //     //     'hello-world-html',
    //     //     (int viewId) => IFrameElement()
    //     //       ..width = '640'
    //     //       ..height = '360'
    //     //       ..src = 'https://www.youtube.com/embed/IyFZznAk69U'
    //     //       ..style.border = 'none');
    // try {
    //   UrlUtils.open('https://meet.jit.si/signnow1');
    // } catch (e) {
    //   print(e);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildNavBar(context: context, title: '', role: ''),
        body: Builder(
          builder: (context) {
            return WebView(
              initialUrl: videoUrl,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageStarted: (url) {
                if (url != videoUrl) print('changed url ');
              },
              onWebResourceError: (error) => print(error),

              // onWebViewCreated: (WebViewController webViewController) {
              //   _controller = webViewController;
              // },
            );
          },
        )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  // _loadHtmlFromAssets() async {
  //
  //   String fileText = loadString('videoBuild/index.html');
  //
  //   _controller.loadUrl(Uri.dataFromString(fileText,
  //           mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }
}
