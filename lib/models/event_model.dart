import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime date;
  final String type; // 'todo', 'schedule', 'eos', etc.
  final String targetPage;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.targetPage,
  });
}
