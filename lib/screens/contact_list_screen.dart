import 'package:flutter/material.dart';
import 'package:oneline/models/contact_model.dart';
import 'package:oneline/screens/add_contact_page.dart';

class ContactListScreen extends StatelessWidget {
  final List<Contact> contacts = [
    // 샘플 연락처 데이터
    Contact(
        name: 'John Doe', phone: '123-456-7890', email: 'john.doe@example.com'),
    Contact(
        name: 'Jane Smith',
        phone: '987-654-3210',
        email: 'jane.smith@example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            onTap: () {
              // 연락처 세부 정보 페이지로 이동하도록 구현할 수 있습니다.
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
