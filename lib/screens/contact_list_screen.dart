import 'package:flutter/material.dart';
import 'package:oneline/models/contact_model.dart';
import 'package:oneline/screens/add_contact_page.dart';
import 'package:oneline/screens/contact_detail_page.dart'; // 추가

class ContactListScreen extends StatelessWidget {
  final List<Contact> contacts = [
    // 샘플 연락처 데이터
    Contact(name: '김재영', phone: '010-1234-5678', email: 'abc123@google.com'),
    Contact(name: '박준하', phone: '010-2345-6789', email: 'abc456@google.com'),
    Contact(name: '김관중', phone: '010-3456-7890', email: 'abc789@google.com'),
  ];

  ContactListScreen({super.key});

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailPage(contact: contact),
                ),
              );
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
