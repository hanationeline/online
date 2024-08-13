import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneline/models/eosl_model.dart';
import 'package:oneline/models/eosl_provider.dart';
import 'package:oneline/widgets/animated_search_bar.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class EoslListPage extends StatefulWidget {
  const EoslListPage({super.key});

  @override
  State<EoslListPage> createState() => _EoslListPageState();
}

class _EoslListPageState extends State<EoslListPage> {
  bool isFolded = true;
  String searchTerm = '';
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    print('EoslListPage initstate 호출');
    loadEoslData();
  }

  void loadEoslData() async {
    try {
      print("loadEoslData 호출됨");
      final eoslProvider = context.read<EoslProvider>();
      final eoslList = await eoslProvider.getEoslList();
      print("데이터 로드 성공: ${eoslList.length}개의 EOSL 항목");

      final Map<String, EoslModel> eoslMap = {
        for (var eosl in eoslList) eosl.eoslNo: eosl
      };

      setState(() {
        eoslProvider.eoslList.addAll(eoslMap);
        rows = createRows();
        print("rows 생성 완료: ${rows.length}개의 행 생성");
      });
    } catch (e) {
      print("데이터 로드 중 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final eoslProvider = context.watch<EoslProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EOSL List'),
        backgroundColor: Colors.teal,
      ),
      body: eoslProvider.getAllEoslList.isEmpty
          // 조회 실패 시 프로그레스 아이콘 표시
          ? const Center(
              child: CircularProgressIndicator(),
            )
          // 조회 성공 시 화면 표시
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedSearchBar(
                    folded: isFolded,
                    onSearch: (String searchTerm) {
                      setState(() {
                        searchTerm = searchTerm;
                        rows = createRows();
                        highlightSearchResult(); // TODO: highlight 메소드 모듈화
                      });
                    },
                    onFoldChange: () {
                      setState(() {
                        isFolded = !isFolded;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: PlutoGrid(
                      columns: createColumns(), rows: rows,
                      // onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event){
                      //   // TODO: 더블클릭 시
                      // }
                      configuration: const PlutoGridConfiguration(
                        style: PlutoGridStyleConfig(
                          activatedColor: Colors.tealAccent,
                          gridBorderColor: Colors.teal,
                          gridBackgroundColor: Colors.white,
                          columnTextStyle: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                          cellTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        columnSize: PlutoGridColumnSizeConfig(
                          autoSizeMode: PlutoAutoSizeMode.scale,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void highlightSearchResult() {}

  List<PlutoColumn> createColumns() {
    return [
      PlutoColumn(
        title: '1',
        field: 'eosl_no',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '호스트이름',
        field: 'host_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '업무명',
        field: 'business_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'IP',
        field: 'ip_address',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '플랫폼',
        field: 'platform',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'OS이름 및 버전',
        field: 'os_version',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'EOSL날짜',
        field: 'eosl_date',
        type: PlutoColumnType.date(),
        // 날짜가 없을 경우
        formatter: (dynamic value) {
          return value == null ? '' : value.toString().split('T').first;
        },
      ),
    ];
  }

  List<PlutoRow> createRows() {
    print("createRows 메소드 호출 완료");
    final eoslProvider = context.read<EoslProvider>();
    return eoslProvider.getAllEoslList.values.map((server) {
      return PlutoRow(
        cells: {
          'server_no': PlutoCell(value: server.eoslNo),
          'host_name': PlutoCell(value: server.hostName),
          'business_name': PlutoCell(value: server.businessName),
          'ip': PlutoCell(value: server.ipAddress),
          'platform': PlutoCell(value: server.platform),
          'os_version': PlutoCell(value: server.osVersion),
          // 'eosl_date': PlutoCell(
          // value: server.eoslDate.toIso8601String().split('T').first),
          'eosl_date': PlutoCell(
              value: server.eoslDate != null
                  ? server.eoslDate!.toIso8601String().split('T').first
                  : ''), // null 처리
        },
      );
    }).toList();
  }
}
