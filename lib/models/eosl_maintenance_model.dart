// lib/models/eosl_maintenance.dart
class EoslMaintenance {
  final String maintenanceNo;
  final String hostName;
  final List<Map<String, dynamic>> tasks;

  EoslMaintenance({
    required this.maintenanceNo,
    required this.hostName,
    required this.tasks,
  });

  factory EoslMaintenance.fromJson(Map<String, dynamic> json) {
    return EoslMaintenance(
      maintenanceNo: json['eosl_maintenance_no'],
      hostName: json['hostName'],
      tasks: List<Map<String, dynamic>>.from(
          json['tasks'].map((task) => Map<String, dynamic>.from(task))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eosl_maintenance_no': maintenanceNo,
      'hostName': hostName,
      'tasks': tasks,
    };
  }
}
