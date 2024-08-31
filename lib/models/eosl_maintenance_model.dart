// lib/models/eosl_maintenance.dart
class EoslMaintenance {
  final String maintenanceNo;
  final String hostName;
  final List<Map<String, dynamic>> tasks; // 작업 이력

  EoslMaintenance({
    required this.maintenanceNo,
    required this.hostName,
    required this.tasks,
  });

  // JSON 데이터를 EoslMaintenance 객체로 변환하는 메서드
  factory EoslMaintenance.fromJson(Map<String, dynamic> json) {
    return EoslMaintenance(
      maintenanceNo: json['eosl_maintenance_no'],
      hostName: json['hostName'],
      tasks: List<Map<String, dynamic>>.from(
          json['tasks'].map((task) => Map<String, dynamic>.from(task))),
    );
  }

  // EoslMaintenance 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'eosl_maintenance_no': maintenanceNo,
      'hostName': hostName,
      'tasks': tasks,
    };
  }
}
