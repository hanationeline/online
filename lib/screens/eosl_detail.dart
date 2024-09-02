// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:oneline/models/eosl_model.dart';
// import 'package:oneline/models/eosl_detail_model.dart';
// import 'package:oneline/models/eosl_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:oneline/widgets/eosl_info_widget.dart';
// import 'package:oneline/widgets/items_per_page.dart';
// import 'package:oneline/widgets/task_card.dart';
// import 'package:oneline/widgets/date_range_selector.dart';
// import 'package:oneline/widgets/search_bar.dart';

// class EoslDetailPage extends StatefulWidget {
//   final String hostName;

//   const EoslDetailPage({
//     super.key,
//     required this.hostName,
//   });

//   @override
//   _EoslDetailPageState createState() => _EoslDetailPageState();
// }

// class _EoslDetailPageState extends State<EoslDetailPage> {
//   int itemsPerPage = 10; // 한 페이지에 보여줄 아이템 수
//   int currentPage = 1; // 현재 페이지 번호
//   DateTimeRange selectedDateRange = DateTimeRange(
//     start: DateTime.now().subtract(const Duration(days: 30)),
//     end: DateTime.now().add(const Duration(days: 7)),
//   ); // 기본 기간 설정 (현재 날짜부터 한달 전까지)
//   String searchQuery = ""; // 검색할 텍스트

//   Future<void> _loadData({
//     String? searchQuery,
//   }) async {
//     final eoslProvider = context.read<EoslProvider>();
//     print("eosl_detail: 검색어는:$searchQuery");
//     // 데이터 로드
//     await eoslProvider.getEoslList();
//     await eoslProvider.getEoslDetailList();
//     await eoslProvider.getEoslMaintenanceList(); // 유지보수 이력 로드

//     // 데이터 로드 후, 디버깅 로그로 확인
//     // print('EoslDetailPage: 데이터 로드 완료');
//     // print('호스트네임: ${widget.hostName}');
//     // print('Eosl 목록: ${eoslProvider.getAllEoslList.keys}');
//     // print('Eosl 상세 목록: ${eoslProvider.getAllDetailEoslList.keys}');
//   }

//   void _filterTasks(DateTimeRange range) {
//     setState(() {
//       selectedDateRange = range;
//       currentPage = 1; // 필터 적용 시 첫 페이지로 리셋
//     });
//   }

//   // void _searchTasks(String query) {
//   //   setState(() {
//   //     searchQuery = query.toLowerCase(); // 검색어를 소문자로 변환
//   //     currentPage = 1; // 첫 페이지로 리셋
//   //   });
//   // }

//   void _addTask() async {
//     final eoslProvider = context.read<EoslProvider>();

//     // 유지보수 이력 리스트 로드
//     final maintenanceList = await eoslProvider.getEoslMaintenanceList();

//     // 새로운 eosl_maintenance_no 생성 (기존 리스트의 길이 + 1)
//     final newMaintenanceNo =
//         (maintenanceList.length + 1).toString().padLeft(3, '0');

//     // EoslHistory 페이지로 이동하여 새로운 Task 추가
//     context.go(
//       '/mainnavi/eosl_list/eosl_detail/${widget.hostName}/history?taskIndex=$newMaintenanceNo',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('EOSL 상세 정보'),
//         backgroundColor: Colors.teal,
//       ),
//       body: FutureBuilder<void>(
//         future: _loadData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('데이터 로드 중 오류가 발생했습니다.'));
//           }

//           final eoslProvider = context.watch<EoslProvider>();
//           final hostNameKey = widget.hostName.trim().toLowerCase();
//           final eoslModel = eoslProvider.getEoslByHostName(hostNameKey);
//           final eoslDetailModel =
//               eoslProvider.getEoslDetailByHostName(hostNameKey);
//           final eoslMaintenance =
//               eoslProvider.getEoslMaintenanceByHostName(hostNameKey);

//           if (eoslModel == null ||
//               eoslDetailModel == null ||
//               eoslMaintenance == null) {
//             return const Center(child: Text('해당 호스트 정보를 찾을 수 없습니다.'));
//           }

//           // 필터링된 TaskCard만 보이도록 설정
//           final filteredTasks = _getFilteredTasks(
//               selectedDateRange, searchQuery, eoslMaintenance.tasks);

//           // 페이지 수 계산
//           final totalPages =
//               (filteredTasks.length / itemsPerPage).ceil(); // 총 페이지 수 계산

//           // 현재 페이지에 맞는 TaskCard 가져오기
//           final visibleTasks = filteredTasks
//               .skip((currentPage - 1) * itemsPerPage)
//               .take(itemsPerPage)
//               .toList();

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               EoslInfoWidget(eoslDetailModel: eoslDetailModel),
//               const SizedBox(height: 16),

//               Center(
//                 child: CustomSearchBar(
//                   onSearch: (value) {
//                     _loadData(searchQuery: value);
//                   },
//                 ),
//               ),
//               const SizedBox(height: 18),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 50.0),
//                 child: Container(
//                   padding: const EdgeInsets.all(9),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: ItemsPerPageSelector(
//                           currentValue: itemsPerPage,
//                           onChanged: (value) {
//                             setState(() {
//                               itemsPerPage = value;
//                               currentPage = 1;
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: DateRangeSelector(
//                           initialDateRange: selectedDateRange,
//                           onSearch: _filterTasks,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Text(
//                   '유지보수 이력',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3, // 한 행에 card 3개씩 표시
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       childAspectRatio:
//                           (MediaQuery.of(context).size.width / 3 - 20) / 300,
//                     ),
//                     itemCount:
//                         visibleTasks.length + 1, // 유지보수 이력 개수 + 1 (플러스 버튼)
//                     itemBuilder: (context, index) {
//                       if (index == 0) {
//                         // 첫 번째 카드에 새로운 Task 추가 버튼 배치
//                         return GestureDetector(
//                           onTap: _addTask,
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16)),
//                             color: Colors.teal.shade50,
//                             child: const Center(
//                               child:
//                                   Icon(Icons.add, size: 50, color: Colors.teal),
//                             ),
//                           ),
//                         );
//                       }

//                       final task = visibleTasks[index - 1];
//                       return TaskCard(
//                         task: task, // TaskCard에 task 데이터 전달
//                         onTap: () {
//                           // 작업 상세보기 로직
//                           context.go(
//                             '/mainnavi/eosl_list/eosl_detail/${widget.hostName}/history?taskIndex=${index - 1}',
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // 페이지 네비게이션 버튼 추가
//               if (totalPages > 1)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back),
//                         onPressed: currentPage > 1
//                             ? () {
//                                 setState(() {
//                                   currentPage--;
//                                 });
//                               }
//                             : null,
//                       ),
//                       Text('Page $currentPage of $totalPages'),
//                       IconButton(
//                         icon: const Icon(Icons.arrow_forward),
//                         onPressed: currentPage < totalPages
//                             ? () {
//                                 setState(() {
//                                   currentPage++;
//                                 });
//                               }
//                             : null,
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // 선택된 날짜 범위와 검색어에 맞는 TaskCard 필터링
//   List<Map<String, dynamic>> _getFilteredTasks(
//       DateTimeRange range, String query, List<Map<String, dynamic>> tasks) {
//     return tasks.where((task) {
//       final taskDate =
//           task['date'] != null ? DateTime.tryParse(task['date']) : null;
//       final taskContent = task['content']?.toLowerCase() ?? '';
//       final taskNotes = task['notes']?.toLowerCase() ?? '';

//       // 날짜 필터링 및 검색어 필터링 적용
//       return (taskDate == null ||
//               (taskDate.isAfter(range.start) &&
//                   taskDate.isBefore(range.end))) &&
//           (taskContent.contains(query) || taskNotes.contains(query));
//     }).toList();
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:oneline/models/eosl_model.dart';
import 'package:oneline/models/eosl_detail_model.dart';
import 'package:oneline/models/eosl_provider.dart';
import 'package:provider/provider.dart';
import 'package:oneline/widgets/eosl_info_widget.dart';
import 'package:oneline/widgets/items_per_page.dart';
import 'package:oneline/widgets/task_card.dart';
import 'package:oneline/widgets/date_range_selector.dart';
import 'package:oneline/widgets/search_bar.dart';

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
  int itemsPerPage = 10; // 한 페이지에 보여줄 아이템 수
  int currentPage = 1; // 현재 페이지 번호
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now().add(const Duration(days: 7)),
  ); // 기본 기간 설정 (현재 날짜부터 한달 전까지)
  String searchQuery = ""; // 검색할 텍스트
  List<Map<String, dynamic>> tasks = []; // 전체 Task 리스트
  List<Map<String, dynamic>> visibleTasks = []; // 필터링된 Task 리스트

  @override
  void initState() {
    super.initState();
    _loadData(); // 초기 데이터 로드
  }

  Future<void> _loadData() async {
    final eoslProvider = context.read<EoslProvider>();

    // 데이터 로드
    await eoslProvider.getEoslList();
    await eoslProvider.getEoslDetailList();
    await eoslProvider.getEoslMaintenanceList(); // 유지보수 이력 로드

    // print('Eosl 유지보수 목록: ${eoslProvider.getAllEoslMaintenanceList.keys}');

    final maintenanceList = await eoslProvider.getEoslMaintenanceList();

    // 호스트 이름과 일치하는 모든 유지보수 이력 가져오기
    final hostNameKey = widget.hostName.trim().toLowerCase();
    final matchingMaintenances = maintenanceList.where((maintenance) {
      return maintenance.hostName.trim().toLowerCase() == hostNameKey;
    }).toList();

    // 유지보수 항목 병합
    final allTasks = <Map<String, dynamic>>[];
    for (var maintenance in matchingMaintenances) {
      allTasks.addAll(maintenance.tasks);
      // print("유지보수는 $maintenance");
    }

    setState(() {
      tasks = allTasks; // 필터링된 유지보수 항목을 전체 Task 리스트로 설정
      _applyFilters(); // 초기 필터링 적용
    });

    // 유지보수 데이터 개수 확인 및 모든 항목 출력
    print('EoslDetailPage: 유지보수 데이터 개수: ${tasks.length}');
    // for (int i = 0; i < tasks.length; i++) {
    //   final task = tasks[i];
    //   print('EoslDetailPage: 유지보수 항목 $i: $task');
    // }
  }

  void _applyFilters() {
    // 필터링된 TaskCard를 업데이트
    final filteredTasks =
        _getFilteredTasks(selectedDateRange, searchQuery, tasks);

    setState(() {
      visibleTasks = filteredTasks
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage)
          .toList();
    });
  }

  void _filterTasks(DateTimeRange range) {
    setState(() {
      selectedDateRange = range;
      currentPage = 1; // 필터 적용 시 첫 페이지로 리셋
    });
    _applyFilters(); // 필터링 적용
  }

  void _searchTasks(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // 검색어를 소문자로 변환
      currentPage = 1; // 첫 페이지로 리셋
    });
    _applyFilters(); // 검색어에 따른 필터링 적용
  }

  void _addTask() async {
    final eoslProvider = context.read<EoslProvider>();

    // 유지보수 이력 리스트 로드
    final maintenanceList = await eoslProvider.getEoslMaintenanceList();

    // 새로운 eosl_maintenance_no 생성 (기존 리스트의 길이 + 1)
    final newMaintenanceNo =
        (maintenanceList.length + 1).toString().padLeft(3, '0');

    // EoslHistory 페이지로 이동하여 새로운 Task 추가
    context.go(
      '/mainnavi/eosl_list/eosl_detail/${widget.hostName}/history?taskIndex=$newMaintenanceNo',
    );
  }

  @override
  Widget build(BuildContext context) {
    final eoslProvider = context.watch<EoslProvider>();
    final hostNameKey = widget.hostName.trim().toLowerCase();
    final eoslDetailModel = eoslProvider.getEoslDetailByHostName(hostNameKey);

    if (eoslDetailModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('EOSL 상세 정보'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(child: Text('해당 호스트 정보를 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EOSL 상세 정보'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EoslInfoWidget(eoslDetailModel: eoslDetailModel),
          const SizedBox(height: 16),

          Center(
            child: CustomSearchBar(
              onSearch: _searchTasks, // 실시간 검색어 반영
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ItemsPerPageSelector(
                      currentValue: itemsPerPage,
                      onChanged: (value) {
                        setState(() {
                          itemsPerPage = value;
                          currentPage = 1;
                        });
                        _applyFilters(); // 아이템 수 변경 시 필터링 적용
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DateRangeSelector(
                      initialDateRange: selectedDateRange,
                      onSearch: _filterTasks,
                    ),
                  ),
                ],
              ),
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
                  crossAxisCount: 3, // 한 행에 card 3개씩 표시
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      (MediaQuery.of(context).size.width / 3 - 20) / 300,
                ),
                itemCount: visibleTasks.length + 1, // 유지보수 이력 개수 + 1 (플러스 버튼)
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // 첫 번째 카드에 새로운 Task 추가 버튼 배치
                    return GestureDetector(
                      onTap: _addTask,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.teal.shade50,
                        child: const Center(
                          child: Icon(Icons.add, size: 50, color: Colors.teal),
                        ),
                      ),
                    );
                  }

                  final task = visibleTasks[index - 1];
                  return TaskCard(
                    task: task, // TaskCard에 task 데이터 전달
                    onTap: () {
                      // 작업 상세보기 로직
                      context.push(
                        '/mainnavi/eosl_list/eosl_detail/${widget.hostName}/history?taskIndex=${index - 1}',
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // 페이지 네비게이션 버튼 추가
          if ((visibleTasks.length / itemsPerPage).ceil() > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentPage > 1
                        ? () {
                            setState(() {
                              currentPage--;
                            });
                            _applyFilters();
                          }
                        : null,
                  ),
                  Text(
                      'Page $currentPage of ${(visibleTasks.length / itemsPerPage).ceil()}'),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentPage <
                            (visibleTasks.length / itemsPerPage).ceil()
                        ? () {
                            setState(() {
                              currentPage++;
                            });
                            _applyFilters();
                          }
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 선택된 날짜 범위와 검색어에 맞는 TaskCard 필터링
  List<Map<String, dynamic>> _getFilteredTasks(
      DateTimeRange range, String query, List<Map<String, dynamic>> tasks) {
    return tasks.where((task) {
      final taskDate =
          task['date'] != null ? DateTime.tryParse(task['date']) : null;
      final taskContent = task['content']?.toLowerCase() ?? '';
      final taskNotes = task['notes']?.toLowerCase() ?? '';

      // 날짜 필터링 및 검색어 필터링 적용
      return (taskDate == null ||
              (taskDate.isAfter(range.start) &&
                  taskDate.isBefore(range.end))) &&
          (taskContent.contains(query) || taskNotes.contains(query));
    }).toList();
  }
}
