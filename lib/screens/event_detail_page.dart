import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/event_model.dart';
import 'package:oneline/provider/event_provider.dart';
import 'edit_event_page.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Event Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final updatedEvent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEventPage(event: event),
                    ),
                  );
                  if (updatedEvent != null && updatedEvent is Event) {
                    eventProvider.removeEvent(event);
                    eventProvider.addEvent(updatedEvent);
                    Navigator.pop(context, updatedEvent);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('삭제'),
                      content: const Text('삭제 하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            eventProvider.removeEvent(event);
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(context); // Close the EventDetailPage
                          },
                          child: const Text('삭제'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Start Time: ${DateFormat.jm().format(event.startTime)}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'End Time: ${DateFormat.jm().format(event.endTime)}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Description:',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
