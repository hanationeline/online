import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    loadEoslData();
  }

  void loadEoslData() async {
    await context.read<EoslProvider>().getEoslList();
    setState(() {
      rows = createRows();
    });
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
                        rows = createRows(); // TODO: plutogrid row 생성
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
                      // onLoaded: (PlutoGridOnLoadedEvent(event){
                      //   stateManager = event.stateManager;
                      // },
                      // onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event){
                      //   // TODO: 더블클릭 시
                      // }
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
          'eosl_date': PlutoCell(
              value: server.eoslDate.toIso8601String().split('T').first),
        },
      );
    }).toList();
  }
}
