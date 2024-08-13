import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneline/models/eosl_model.dart';

class EoslProvider with ChangeNotifier {
  final Map<String, EoslModel> eoslList = {};

  Future<List<EoslModel>> getEoslList() async {
    final List<EoslModel> eoslInstances = [];
    final eoslJsonData =
        await rootBundle.loadString('lib/assets/eosl_list.json');
    // TODO: 나중에 db가져오는 데이터 링크로 변경되어야 함

    if (eoslJsonData.isNotEmpty) {
      final List<dynamic> eoslList = jsonDecode(eoslJsonData);
      for (var eosl in eoslList) {
        final eoslModel = EoslModel.fromJson(eosl);
        print('호스트네임은: ${eoslModel.hostName}');
        eoslInstances.add(eoslModel);
      }

      return eoslInstances;
    }
    throw Error();
  }

  // eosl id로 EOSL 조회
  EoslModel? getEoslByNo(String eoslNo) {
    return eoslList[eoslNo];
  }

  // 모든 EOSL리스트 반환
  Map<String, EoslModel> get getAllEoslList => eoslList;
}
