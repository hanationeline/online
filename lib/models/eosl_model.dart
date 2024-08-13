class EoslModel {
  final String eoslNo;
  final String hostName;
  final String businessName;
  final String ipAddress;
  final String platform;
  final String osVersion;
  final DateTime? eoslDate;

  EoslModel.fromJson(Map<String, dynamic> json)
      : eoslNo = json['eosl_no'],
        hostName = json['host_name'],
        businessName = json['business_name'],
        ipAddress = json['ip_address'],
        platform = json['platform'],
        osVersion = json['os_version'],
        // eoslDate =
        //     json['eosl_date'] != null ? DateTime.parse(json['eoslDate']) : null;
        eoslDate = json['eosl_date'] != null && json['eosl_date'] is String
            ? DateTime.tryParse(json['eosl_date'])
            : null;
}
