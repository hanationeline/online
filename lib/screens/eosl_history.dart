import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneline/models/eosl_detail_model.dart';
import 'package:oneline/models/eosl_model.dart';
import 'package:oneline/models/contact_model.dart'; // Import the Contact model
import 'package:oneline/models/eosl_provider.dart'; // Import EOSL provider
import 'package:oneline/models/contact_provider.dart'; // Import Contact provider
import 'package:provider/provider.dart'; // Import provider for state management

class EoslHistoryPage extends StatelessWidget {
  final String hostName;
  final int taskIndex;

  const EoslHistoryPage({
    super.key,
    required this.hostName,
    required this.taskIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Fetching EoslDetailModel data from the provider using the hostName
    final eoslDetail =
        context.read<EoslProvider>().getEoslDetailByHostName(hostName);

    // Fetching Contact data based on the supplier of EoslDetailModel
    final contact = eoslDetail != null
        ? context
            .read<ContactProvider>()
            .getContactByWorkplace(eoslDetail.supplier)
        : null;

    // Creating temporary data if contact is not found
    final Contact tempContact = Contact(
      name: '임시 데이터', // Temporary name
      phone: '010-1234-5678', // Temporary phone
      email: 'temp@company.com', // Temporary email
      workplace: eoslDetail?.supplier ?? 'Unknown', // Temporary workplace
      notes: 'This is a temporary contact record.', // Temporary notes
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('유지보수 작업 상세: $hostName'),
        backgroundColor: Colors.teal,
      ),
      body: eoslDetail == null
          ? const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: EoslDetailModel ListTile
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: _boxDecoration(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildEoslDetailTile(context, eoslDetail),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Right side: Contact ListTile
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: _boxDecoration(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildContactTile(context, contact ?? tempContact),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // BoxDecoration for the cards
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Method to create the EoslDetailModel list tile
  Widget _buildEoslDetailTile(BuildContext context, EoslDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          title: Text(
            'Host Name: ${detail.hostName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Field: ${detail.field}'),
              Text('Quantity: ${detail.quantity}'),
              Text('Note: ${detail.note}'),
              Text('Supplier: ${detail.supplier}'),
              Text(
                'EOSL Date: ${detail.eoslDate != null ? DateFormat('yyyy-MM-dd').format(detail.eoslDate!) : 'None'}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Method to create the Contact list tile
  Widget _buildContactTile(BuildContext context, Contact contact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          title: Text(
            'Name: ${contact.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone: ${contact.phone}'),
              Text('Email: ${contact.email}'),
              Text('Workplace: ${contact.workplace}'),
              Text('Notes: ${contact.notes}'),
            ],
          ),
        ),
      ],
    );
  }
}
