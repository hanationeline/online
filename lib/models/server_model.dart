import 'dart:convert';

class ServerModel {
  final String serverNo;
  final String serviceGroupName;
  final String networkConnection;
  final String environment;
  final String department;
  final String serverType;
  final String osType;
  final String hostName;
  final String serviceName;
  final String ip;
  final String adminAccount;
  final String osVersion;
  final DateTime eoslDate;

  ServerModel({
    required this.serverNo,
    required this.serviceGroupName,
    required this.networkConnection,
    required this.environment,
    required this.department,
    required this.serverType,
    required this.osType,
    required this.hostName,
    required this.serviceName,
    required this.ip,
    required this.adminAccount,
    required this.osVersion,
    required this.eoslDate,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      serverNo: json['server_no'] ?? '',
      serviceGroupName: json['service_group_name'] ?? '',
      networkConnection: json['network_connection'] ?? '',
      environment: json['environment'] ?? '',
      department: json['department'] ?? '',
      serverType: json['server_type'] ?? '',
      osType: json['os_type'] ?? '',
      hostName: json['host_name'] ?? '',
      serviceName: json['service_name'] ?? '',
      ip: json['ip'] ?? '',
      adminAccount: json['admin_account'] ?? '',
      osVersion: json['os_version'] ?? '',
      eoslDate: DateTime.tryParse(json['eosl_date'] ?? '') ?? DateTime.now(),
    );
  }
}
