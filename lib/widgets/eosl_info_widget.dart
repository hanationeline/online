import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneline/models/eosl_detail_model.dart'; // EoslDetailModel을 추가한 파일

class EoslInfoWidget extends StatelessWidget {
  final EoslDetailModel eoslDetailModel;

  const EoslInfoWidget({
    super.key,
    required this.eoslDetailModel,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('호스트 네임:', eoslDetailModel.hostName),
          _buildInfoRow('구분:', eoslDetailModel.field),
          _buildInfoRow('상세:', eoslDetailModel.note),
          _buildInfoRow('수량:', eoslDetailModel.quantity),
          _buildInfoRow('납품업체:', eoslDetailModel.supplier),
          _buildInfoRow(
            'EOS 날짜:',
            eoslDetailModel.eoslDate != null
                ? DateFormat('yyyy-MM-dd').format(eoslDetailModel.eoslDate!)
                : '없음',
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
            label,
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
