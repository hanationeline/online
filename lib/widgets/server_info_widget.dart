import 'package:flutter/material.dart';
import 'package:oneline/models/server_model.dart';

class ServerInfoWidget extends StatelessWidget {
  final ServerModel server;
  final VoidCallback onCalendarPressed;

  const ServerInfoWidget({
    super.key,
    required this.server,
    required this.onCalendarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.teal.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Server No:', server.serverNo),
                _buildInfoRow('Host Name:', server.hostName),
                _buildInfoRow('Service Group:', server.serviceGroupName),
                _buildInfoRow('OS Type:', server.osType),
                _buildInfoRow('OS Version:', server.osVersion),
                _buildInfoRow('Service Name:', server.serviceName),
                _buildInfoRow('IP:', server.ip),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.teal.shade700),
            onPressed: onCalendarPressed,
            tooltip: 'Register EOSL Date',
            iconSize: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(197, 0, 121, 107),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
