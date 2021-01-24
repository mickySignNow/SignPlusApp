import 'package:flutter/cupertino.dart';

class NavigationRoutes {
  static final RouteSettings mainPage = RouteSettings(name: 'Sign+App');
  static final RouteSettings dashboard = RouteSettings(name: 'dashboard');
  static final RouteSettings createScreen = RouteSettings(name: 'createScreen');
  static final RouteSettings login = RouteSettings(name: 'Welcome');
  static final RouteSettings admintabs = RouteSettings(name: 'AdminPage');
  static final RouteSettings admin = RouteSettings(name: 'admin');
}

class PageRoutePath {
  final String id;

  PageRoutePath.home() : id = null;

  PageRoutePath.details(this.id);

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}
