import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:oneline/models/server_model.dart';
import 'package:oneline/models/server_provider.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:oneline/widgets/animated_search_bar.dart';
import 'package:provider/provider.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  _ServerListState createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  final bool _folded = true;
  String _searchTerm = '';
  List<PlutoRow> _rows = [];
  late PlutoGridStateManager stateManager;
  PlutoRowColorCallback? rowColorCallback;

  @override
  void initState() {
    super.initState();
    _loadServerDataIfNeeded();
  }

  void _loadServerDataIfNeeded() async {
    final serverProvider = context.read<ServerProvider>();

    // 데이터가 없으면 fetchServers 호출
    if (serverProvider.allServers.isEmpty) {
      await serverProvider.fetchServers();
    }

    setState(() {
      _rows = _createRows();
    });
  }

  @override
  Widget build(BuildContext context) {
    final serverProvider = context.watch<ServerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Server List'),
        backgroundColor: Colors.teal,
      ),
      body: serverProvider.allServers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedSearchBar(
                    // folded: _folded,
                    onSearch: (String searchTerm) {
                      setState(() {
                        _searchTerm = searchTerm;
                        _rows = _createRows();
                        highlightSearchResult();
                      });
                    },
                    // onFoldChange: () {
                    //   setState(() {
                    //     _folded = !_folded;
                    //   });
                    // },
                    // rows: _rows,
                    // stateManager: stateManager,
                    // searchTerm: _searchTerm,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: PlutoGrid(
                      columns: _createColumns(),
                      rows: _rows,
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        stateManager = event.stateManager;
                      },
                      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                        final row = event.row;
                        final serverNo = row.cells['server_no']?.value ?? '';
                        final server = serverProvider.getServerByNo(serverNo);
                        if (server != null) {
                          context.go(
                              '/mainnavi/server_list/server_detail/${server.serverNo}',
                              extra: server);
                        }
                      },
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

  // 검색 하이라이트 기능
  void highlightSearchResult() {
    final matchingRows = stateManager.rows.where((row) {
      return row.cells.entries.any((entry) {
        return entry.value.value
            .toString()
            .toLowerCase()
            .contains(_searchTerm.toLowerCase());
      });
    }).toList();

    if (matchingRows.isNotEmpty) {
      setState(() {
        rowColorCallback = (PlutoRowColorContext rowColorContext) {
          if (matchingRows.contains(rowColorContext.row)) {
            return const Color.fromARGB(255, 198, 235, 14); // 검색된 행의 색상 변경
          }
          return const Color.fromARGB(194, 246, 4, 4);
        };

        stateManager.setCurrentCell(
          matchingRows.first.cells.entries.first.value,
          stateManager.refRows.indexOf(matchingRows.first),
        );
        stateManager.moveScrollByRow(
          PlutoMoveDirection.up,
          stateManager.refRows.indexOf(matchingRows.first),
        );
      });
    }
  }

  ServerModel _getServerFromRow(PlutoRow row) {
    final serverNo = row.cells['server_no']?.value ?? '';
    final serviceGroupName = row.cells['service_group_name']?.value ?? '';
    final networkConnection = row.cells['network_connection']?.value ?? '';
    final environment = row.cells['environment']?.value ?? '';
    final department = row.cells['department']?.value ?? '';
    final serverType = row.cells['server_type']?.value ?? '';
    final osType = row.cells['os_type']?.value ?? '';
    final hostName = row.cells['host_name']?.value ?? '';
    final serviceName = row.cells['service_name']?.value ?? '';
    final ip = row.cells['ip']?.value ?? '';
    final adminAccount = row.cells['admin_account']?.value ?? '';
    final osVersion = row.cells['os_version']?.value ?? '';
    final eoslDate = DateTime.tryParse(row.cells['eosl_date']?.value ?? '') ??
        DateTime.now();

    return ServerModel(
      serverNo: serverNo,
      serviceGroupName: serviceGroupName,
      networkConnection: networkConnection,
      environment: environment,
      department: department,
      serverType: serverType,
      osType: osType,
      hostName: hostName,
      serviceName: serviceName,
      ip: ip,
      adminAccount: adminAccount,
      osVersion: osVersion,
      eoslDate: eoslDate,
    );
  }

// 필드 생성
  List<PlutoColumn> _createColumns() {
    return [
      PlutoColumn(
        title: '서버번호',
        field: 'server_no',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '서비스그룹이름',
        field: 'service_group_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '망연계',
        field: 'network_connection',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '개발/운영',
        field: 'environment',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '담당부서',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '서버종류',
        field: 'server_type',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'OS종류',
        field: 'os_type',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '호스트이름',
        field: 'host_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '서비스이름',
        field: 'service_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'IP',
        field: 'ip',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '관리자계정',
        field: 'admin_account',
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

// 셀 생성
  List<PlutoRow> _createRows() {
    final serverProvider = context.read<ServerProvider>();
    return serverProvider.allServers.values.map((server) {
      return PlutoRow(
        cells: {
          'server_no': PlutoCell(value: server.serverNo ?? ''),
          'service_group_name': PlutoCell(value: server.serviceGroupName ?? ''),
          'network_connection':
              PlutoCell(value: server.networkConnection ?? ''),
          'environment': PlutoCell(value: server.environment ?? ''),
          'department': PlutoCell(value: server.department ?? ''),
          'server_type': PlutoCell(value: server.serverType ?? ''),
          'os_type': PlutoCell(value: server.osType ?? ''),
          'host_name': PlutoCell(value: server.hostName ?? ''),
          'service_name': PlutoCell(value: server.serviceName ?? ''),
          'ip': PlutoCell(value: server.ip ?? ''),
          'admin_account': PlutoCell(value: server.adminAccount ?? ''),
          'os_version': PlutoCell(value: server.osVersion ?? ''),
          'eosl_date': PlutoCell(
              value: server.eoslDate.toIso8601String().split('T').first ?? ''),
        },
      );
    }).toList();
  }

// 셀 값 업데이트
  ServerModel _updateServer(ServerModel server, String field, dynamic value) {
    return ServerModel(
      serverNo: field == 'server_no' ? value : server.serverNo,
      serviceGroupName:
          field == 'service_group_name' ? value : server.serviceGroupName,
      networkConnection:
          field == 'network_connection' ? value : server.networkConnection,
      environment: field == 'environment' ? value : server.environment,
      department: field == 'department' ? value : server.department,
      serverType: field == 'server_type' ? value : server.serverType,
      osType: field == 'os_type' ? value : server.osType,
      hostName: field == 'host_name' ? value : server.hostName,
      serviceName: field == 'service_name' ? value : server.serviceName,
      ip: field == 'ip' ? value : server.ip,
      adminAccount: field == 'admin_account' ? value : server.adminAccount,
      osVersion: field == 'os_version' ? value : server.osVersion,
      eoslDate: field == 'eosl_date' ? DateTime.parse(value) : server.eoslDate,
    );
  }
}
