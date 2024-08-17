class EoslDetailModel {
  final String hostName;
  final String field; // 구분상세
  final String quantity;
  final String note; // 비고
  final String supplier;
  final DateTime? eoslDate;

  EoslDetailModel.fromJson(Map<String, dynamic> json)
      : hostName = json['host_name'],
        field = json['field'],
        quantity = json['quantity'],
        note = json['note'],
        supplier = json['supplier'],
        eoslDate = json['eosl_date'] != null && json['eosl_date'] is String
            ? DateTime.tryParse(json['eosl_date'])
            : null;
}
