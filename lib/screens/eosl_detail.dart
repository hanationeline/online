import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneline/models/eosl_model.dart';
import 'package:oneline/models/eosl_detail_model.dart'; // EoslDetailModel을 추가한 파일
import 'package:oneline/models/eosl_provider.dart';
import 'package:provider/provider.dart';

class EoslDetailPage extends StatefulWidget {
  // final EoslModel eoslModel;
  // final EoslDetailModel eoslDetailModel;
  final String hostName;

  const EoslDetailPage({
    super.key,
    // required this.eoslModel,
    // required this.eoslDetailModel,
    required this.hostName,
  });

  @override
  _EoslDetailPageState createState() => _EoslDetailPageState();
}

class _EoslDetailPageState extends State<EoslDetailPage> {
  EoslModel? eoslModel;
  EoslDetailModel? eoslDetailModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final eoslProvider = context.read<EoslProvider>();

    // 로그 추가: hostName 확인
    print('EoslDetailPage: Fetching details for hostName: ${widget.hostName}');

    eoslDetailModel = eoslProvider.getEoslDetailByHostName(widget.hostName);

    // 로그 추가: EoslDetailModel 확인
    if (eoslDetailModel != null) {
      print('EoslDetailModel found for hostName: ${eoslDetailModel!.hostName}');
    } else {
      print(
          'Error: EoslDetailModel not found for hostName: ${widget.hostName}');
    }
  }

  Future<void> loadData() async {
    final eoslProvider = context.read<EoslProvider>();

    // 데이터를 먼저 불러옴
    await eoslProvider.getEoslList();
    await eoslProvider.getEoslDetailList();

    setState(() {
      eoslModel = eoslProvider.getEoslByHostName(widget.hostName);
      eoslDetailModel = eoslProvider.getEoslDetailByHostName(widget.hostName);
      isLoading = false;
    });

    // 데이터 확인을 위한 로그 추가
    if (eoslModel == null) {
      print('Error: EoslModel not found for hostName: ${widget.hostName}');
    }
    if (eoslDetailModel == null) {
      print(
          'Error: EoslDetailModel not found for hostName: ${widget.hostName}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('EOSL 상세 정보 ${eoslDetailModel?.hostName}'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('EOSL 상세 정보 ${eoslDetailModel?.hostName}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('호스트 네임', eoslDetailModel?.hostName ?? ''),
            _buildDetailRow('구분', eoslDetailModel?.field ?? ''),
            _buildDetailRow('상세', eoslDetailModel?.note ?? ''),
            _buildDetailRow('수량', eoslDetailModel?.quantity ?? ''),
            _buildDetailRow('납품업체', eoslDetailModel?.supplier ?? ''),
            _buildDetailRow(
              'EOS 날짜',
              eoslDetailModel?.eoslDate != null
                  ? DateFormat('yyyy-MM-dd').format(eoslDetailModel!.eoslDate!)
                  : '없음',
            ),
            const SizedBox(height: 16),
            const Text(
              '유지보수 이력',
              // style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildMaintenanceHistory(), // 유지보수 이력 카드
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceHistory() {
    // 유지보수 이력에 해당하는 TaskCard를 그려주는 메소드
    return ListView.builder(
      itemCount: 10, // 실제 유지보수 이력의 길이로 변경해야 합니다.
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('유지보수 Task $index'),
            onTap: () {
              // 작업 상세보기 로직
              // 예를 들어 Navigator.push()로 상세 페이지로 이동할 수 있습니다.
            },
          ),
        );
      },
    );
  }
}
