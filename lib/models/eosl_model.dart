class EoslModel {
  final String eoslNo;
  final String hostName;
  final String businessName;
  final String ipAddress;
  final String platform;
  final String osVersion;
  final DateTime eoslDate;

  EoslModel.fromJson(Map<String, dynamic> json)
      : eoslNo = json['eoslNo'],
        hostName = json['hostName'],
        businessName = json['businessName'],
        ipAddress = json['ipAddress'],
        platform = json['platform'],
        osVersion = json['osVersion'],
        eoslDate = json['eoslDate'];
}
