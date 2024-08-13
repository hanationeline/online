import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneline/models/server_model.dart';
import 'package:intl/intl.dart';
import 'package:oneline/screens/server_history.dart';
import 'package:oneline/widgets/server_info_widget.dart';
import 'package:oneline/widgets/task_card.dart';
import 'package:oneline/models/server_provider.dart';
import 'package:provider/provider.dart';

class ServerDetailPage extends StatefulWidget {
  final ServerModel server;
  final String serverNo;

  const ServerDetailPage({
    super.key,
    required this.server,
    required this.serverNo,
  });

  @override
  _ServerDetailPageState createState() => _ServerDetailPageState();
}

class _ServerDetailPageState extends State<ServerDetailPage> {
  late ServerModel? server;
  DateTimeRange? selectedDateRange;
  int itemsPerPage = 10;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    final serverProvider = context.read<ServerProvider>();
    server = serverProvider.getServerByNo(widget.serverNo);
    if (server == null) {
      print('서버를 가져오지 못하였음');
    }
  }

  void _setPredefinedPeriod(Duration duration) {
    setState(() {
      selectedDateRange = DateTimeRange(
        start: DateTime.now().subtract(duration),
        end: DateTime.now(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (server == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('서버 상세 정보'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: Text('서버 정보를 불러오지 못했습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('업무 히스토리 ${server?.hostName}'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServerInfoWidget(
            server: server!,
            onCalendarPressed: () {
              // TODO: EOSL 날짜를 캘린더에 등록하는 로직 추가
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        initialDateRange: selectedDateRange,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDateRange) {
                        setState(() {
                          selectedDateRange = picked;
                        });
                      }
                    },
                    child: Text(
                      selectedDateRange == null
                          ? '기간 선택'
                          : '선택된 기간: ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () =>
                      _setPredefinedPeriod(const Duration(days: 7)),
                  child: const Text('1주일'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      _setPredefinedPeriod(const Duration(days: 30)),
                  child: const Text('1개월'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      _setPredefinedPeriod(const Duration(days: 90)),
                  child: const Text('3개월'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: itemsPerPage,
                    items: [5, 10, 15, 20].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value 개씩 보이기'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          itemsPerPage = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () {
                    // TODO: 작업 추가 로직 추가
                  },
                  backgroundColor: Colors.teal,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                itemCount: itemsPerPage,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskIndex: index + (currentPage - 1) * itemsPerPage,
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ServerHistoryPage(
                    //         server: server!,
                    //         taskIndex: index + (currentPage - 1) * itemsPerPage,
                    //       ),
                    //     ),
                    //   );
                    // },
                    // onTap: () {
                    //   context.push(
                    //     'history',
                    //     extra: {
                    //       'serverNo': widget.server.serverNo,
                    //       'taskIndex': index
                    //     },
                    //   );
                    // },
                    onTap: () {
                      context.go(
                        '/mainnavi/server_list/server_detail/${widget.serverNo}/history?taskIndex=$index',
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (currentPage > 1) {
                      setState(() {
                        currentPage--;
                      });
                    }
                  },
                ),
                Text('Page $currentPage'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      currentPage++;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
