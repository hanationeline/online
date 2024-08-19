import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneline/models/eosl_model.dart';
import 'package:oneline/models/eosl_detail_model.dart'; // EoslDetailModel을 추가한 파일
import 'package:oneline/models/eosl_provider.dart';
import 'package:oneline/widgets/eosl_info_widget.dart';
import 'package:oneline/widgets/items_per_page.dart';
import 'package:provider/provider.dart';
import 'package:oneline/widgets/task_card.dart';

class EoslDetailPage extends StatefulWidget {
  final String hostName;

  const EoslDetailPage({
    super.key,
    required this.hostName,
  });

  @override
  _EoslDetailPageState createState() => _EoslDetailPageState();
}

class _EoslDetailPageState extends State<EoslDetailPage> {
  int itemsPerPage = 10;

  Future<void> _loadData() async {
    final eoslProvider = context.read<EoslProvider>();

    // 데이터 로드
    await eoslProvider.getEoslList();
    await eoslProvider.getEoslDetailList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EOSL 상세 정보'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<void>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터 로드 중 오류가 발생했습니다.'));
          }

          final eoslProvider = context.read<EoslProvider>();
          final eoslModel = eoslProvider.getEoslByHostName(widget.hostName);
          final eoslDetailModel =
              eoslProvider.getEoslDetailByHostName(widget.hostName);

          if (eoslModel == null || eoslDetailModel == null) {
            return const Center(child: Text('해당 호스트 정보를 찾을 수 없습니다.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EoslInfoWidget(eoslDetailModel: eoslDetailModel),
              const SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         '호스트 네임: ${eoslDetailModel.hostName}',
              //         style: const TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20,
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       _buildDetailRow('구분', eoslDetailModel.field),
              //       _buildDetailRow('상세', eoslDetailModel.note),
              //       _buildDetailRow('수량', eoslDetailModel.quantity),
              //       _buildDetailRow('납품업체', eoslDetailModel.supplier),
              //       _buildDetailRow(
              //         'EOS 날짜',
              //         eoslDetailModel.eoslDate != null
              //             ? DateFormat('yyyy-MM-dd')
              //                 .format(eoslDetailModel.eoslDate!)
              //             : '없음',
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ItemsPerPageSelector(
                  currentValue: itemsPerPage,
                  onChanged: (value) {
                    setState(() {
                      itemsPerPage = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '유지보수 이력',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 cards per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio:
                          (MediaQuery.of(context).size.width / 3 - 20) / 300,
                    ),
                    itemCount: 10, // 유지보수 이력 개수
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskIndex: index,
                        onTap: () {
                          // 작업 상세보기 로직
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
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
}
