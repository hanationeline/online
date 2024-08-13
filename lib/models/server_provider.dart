import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:oneline/models/server_model.dart';

class ServerProvider with ChangeNotifier {
  final Map<String, ServerModel> _servers = {};

  // 서버 데이터를 로컬 JSON 파일로부터 불러오는 메서드
  Future<void> fetchServers() async {
    try {
      final jsonString = await rootBundle.loadString('lib/assets/servers.json');
      final List<dynamic> data = json.decode(jsonString);

      _servers.clear();
      for (var item in data) {
        final server = ServerModel.fromJson(item);
        _servers[server.serverNo] = server;
        // print('아이템은: $item');
      }
      notifyListeners(); // 상태 변경 알림
    } catch (e) {
      print('서버 데이터를 가져오는데 실패했습니다: $e');
    }
  }

  // 서버를 조회하는 메소드
  ServerModel? getServerByNo(String serverNo) {
    print('선택한 서버 넘버는: $serverNo');
    return _servers[serverNo];
  }

  // 모든 서버를 반환하는 메소드
  Map<String, ServerModel> get allServers => _servers;
}
