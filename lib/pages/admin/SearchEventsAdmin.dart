import 'package:flutter/material.dart';
import 'package:sign_plus/utils/FirebaseConstFunctions.dart';

class SearchEventsAdmin extends StatefulWidget {
  @override
  _SearchEventsAdminState createState() => _SearchEventsAdminState();
}

class _SearchEventsAdminState extends State<SearchEventsAdmin> {
  String query;
  List<Map<String, dynamic>> events;
  getAllEvents() async {
    var res = await FirebaseConstFunctions.getAllEvents.call({'': ''});
    events = res.data;
  }

  getEventsSearch() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
