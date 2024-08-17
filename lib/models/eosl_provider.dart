import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneline/models/eosl_detail_model.dart';
import 'package:oneline/models/eosl_model.dart';

class EoslProvider with ChangeNotifier {
  final Map<String, EoslModel> eoslMap = {};
  final Map<String, EoslDetailModel> eoslDetailList = {};
  final List<EoslModel> eoslInstances = [];

  Future<List<EoslModel>> getEoslList() async {
    final eoslJsonData =
        await rootBundle.loadString('lib/assets/eosl_list.json');
    // TODO: 나중에 db가져오는 데이터 링크로 변경되어야 함

    if (eoslJsonData.isNotEmpty) {
      final List<dynamic> eoslList = jsonDecode(eoslJsonData);
      for (var eosl in eoslList) {
        final eoslModel = EoslModel.fromJson(eosl);
        print('EoslProvider: 호스트네임은: ${eoslModel.hostName}');

        eoslMap[eoslModel.hostName] = eoslModel; // 맵에 저장
        eoslInstances.add(eoslModel);
      }
      notifyListeners();
      return eoslInstances;
    }
    throw Error();
  }

  // eosl id로 EOSL 조회
  EoslModel? getEoslByNo(String eoslNo) {
    return eoslMap[eoslNo];
  }

  // hostName으로 EOSL 조회
  EoslModel? getEoslByHostName(String hostName) {
    final eoslModel = eoslMap[hostName];

    print('EoslProvider 호스트네임 조회: ${eoslMap[hostName]}');
    // 로그 추가: 현재 저장된 hostNames 확인
    print('EoslProvider: 현재 저장된 호스트네임들: ${eoslMap.keys}');

    return eoslModel;
  }

  // 모든 EOSL리스트 반환
  Map<String, EoslModel> get getAllEoslList => eoslMap;

  // EOSL 상세 정보 가져오기
  Future<void> getEoslDetailList() async {
    final eoslDetailJsonData =
        await rootBundle.loadString('lib/assets/eosl_detail_list.json');

    if (eoslDetailJsonData.isNotEmpty) {
      final List<dynamic> eoslDetailDataList = jsonDecode(eoslDetailJsonData);
      for (var detail in eoslDetailDataList) {
        final eoslDetailModel = EoslDetailModel.fromJson(detail);

        // 로그 추가: 상세 정보 로드 확인
        print(
            'EoslProvider: 로드된 EoslDetailModel 호스트네임: ${eoslDetailModel.hostName}');

        // hostName을 키로 사용하여 eoslDetailList에 저장
        eoslDetailList[eoslDetailModel.hostName] = eoslDetailModel;
      }
      notifyListeners();
    } else {
      throw Error();
    }
  }

  // hostName으로 EOSL 상세 정보 조회
  EoslDetailModel? getEoslDetailByHostName(String hostName) {
    final eoslDetailModel = eoslDetailList[hostName];

    // 로그 추가: 현재 저장된 상세 정보 hostNames 확인
    print('EoslProvider: 현재 저장된 상세 호스트네임들: ${eoslDetailList.keys}');

    return eoslDetailModel;
  }

  // 모든 EOSL리스트 반환
  Map<String, EoslDetailModel> get getAllDetailEoslList => eoslDetailList;
}
