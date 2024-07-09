import 'package:flutter/material.dart';
import 'event_model.dart';

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  List<Event> getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void addEvent(Event event) {
    if (_events[event.date] != null) {
      _events[event.date]!.add(event);
    } else {
      _events[event.date] = [event];
    }
    notifyListeners();
  }

  void removeEvent(Event event) {
    _events[event.date]?.remove(event);
    notifyListeners();
  }
}
