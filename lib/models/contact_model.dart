import 'package:flutter/material.dart';

class Contact {
  String name;
  String phoneNumber;
  String faxNumber;
  String email;
  String address;
  String organization;
  String title;
  String role;
  String memo;
  DateTime createdAt;
  DateTime modifiedAt;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.faxNumber,
    required this.email,
    required this.address,
    required this.organization,
    required this.title,
    required this.role,
    required this.memo,
    required this.createdAt,
    required this.modifiedAt,
  });
}
