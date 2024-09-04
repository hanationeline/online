import 'package:flutter/material.dart';
import 'package:oneline/models/contact_model.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/contact_provider.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _faxNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _organizationController = TextEditingController();
  final _titleController = TextEditingController();
  final _roleController = TextEditingController();
  final _memoController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        faxNumber: _faxNumberController.text,
        email: _emailController.text,
        address: _addressController.text,
        organization: _organizationController.text,
        title: _titleController.text,
        role: _roleController.text,
        memo: _memoController.text,
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
      );

      Provider.of<ContactProvider>(context, listen: false)
          .addContact(newContact);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('연락처 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _faxNumberController,
                decoration: const InputDecoration(labelText: 'Fax Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a fax number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _organizationController,
                decoration: const InputDecoration(labelText: 'Organization'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an organization';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a role';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(labelText: 'Memo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
