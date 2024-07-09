import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabModel {
  final String title;
  final IconData icon;

  TabModel({required this.title, required this.icon});
}

List<TabModel> tabs = [
  TabModel(title: "Calendar", icon: FontAwesomeIcons.calendarCheck),
  TabModel(title: "Server List", icon: FontAwesomeIcons.server),
  TabModel(title: "Work Schedule", icon: FontAwesomeIcons.solidCalendarCheck),
];
