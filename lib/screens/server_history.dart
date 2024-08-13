import 'package:flutter/material.dart';
import 'package:oneline/models/server_model.dart';

class ServerHistoryPage extends StatelessWidget {
  final ServerModel server;
  final int taskIndex;

  const ServerHistoryPage({
    super.key,
    required this.server,
    required this.taskIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('작업 상세: ${server.serverNo}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작업 제목
            Text(
              '작업 제목: 작업 #$taskIndex',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // 서버 정보
            _buildInfoRow('서버 번호:', server.serverNo),
            _buildInfoRow('호스트 이름:', server.hostName),
            _buildInfoRow('서비스 그룹:', server.serviceGroupName),
            _buildInfoRow('OS 종류:', server.osType),
            _buildInfoRow('OS 버전:', server.osVersion),
            _buildInfoRow('서비스 이름:', server.serviceName),
            _buildInfoRow('IP 주소:', server.ip),
            const SizedBox(height: 16),

            // 작업 세부 사항
            Text(
              '작업 내용:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextFormField(
                initialValue: '작업 #$taskIndex에 대한 자세한 정보',
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '작업 내용을 입력하세요',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 서버 정보를 표시하는 메서드
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$label ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
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
