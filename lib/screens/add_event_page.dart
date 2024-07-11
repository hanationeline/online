import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/event_provider.dart';
import 'package:oneline/models/event_model.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  final DateTime _date = DateTime.now();
  late String _type;
  late String _targetPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Type'),
                items: <String>['todo', 'schedule', 'eos'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  _type = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Target Page'),
                onSaved: (value) {
                  _targetPage = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newEvent = Event(
                      title: _title,
                      description: _description,
                      date: _date,
                      type: _type,
                      targetPage: _targetPage,
                    );
                    Provider.of<EventProvider>(context, listen: false)
                        .addEvent(newEvent);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
