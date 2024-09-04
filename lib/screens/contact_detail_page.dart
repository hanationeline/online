import 'package:flutter/material.dart';
import 'package:oneline/models/contact_model.dart';

class ContactDetailPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Phone Number'),
              subtitle: Text(contact.phoneNumber),
            ),
            ListTile(
              title: const Text('Fax Number'),
              subtitle: Text(contact.faxNumber),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(contact.email),
            ),
            ListTile(
              title: const Text('Address'),
              subtitle: Text(contact.address),
            ),
            ListTile(
              title: const Text('Organization'),
              subtitle: Text(contact.organization),
            ),
            ListTile(
              title: const Text('Title'),
              subtitle: Text(contact.title),
            ),
            ListTile(
              title: const Text('Role'),
              subtitle: Text(contact.role),
            ),
            ListTile(
              title: const Text('Memo'),
              subtitle: Text(contact.memo),
            ),
            ListTile(
              title: const Text('Created At'),
              subtitle: Text(contact.createdAt.toString()),
            ),
            ListTile(
              title: const Text('Modified At'),
              subtitle: Text(contact.modifiedAt.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
