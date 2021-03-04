import 'dart:html' as html;

import 'package:sign_plus/utils/StaticObjects.dart';

setLocalStorage() {
  html.window.localStorage['uid'] = StaticObjects.uid;
}
