import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:oneline/models/eosl_model.dart';
import 'package:oneline/models/eosl_detail_model.dart'; // EoslDetailModel을 추가한 파일
import 'package:oneline/models/eosl_provider.dart';
import 'package:oneline/widgets/animated_search_bar.dart';
import 'package:oneline/widgets/eosl_info_widget.dart';
import 'package:oneline/widgets/items_per_page.dart';
import 'package:provider/provider.dart';
import 'package:oneline/widgets/task_card.dart';
import 'package:oneline/widgets/date_range_selector.dart';

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
  bool isSearchFolded = true; // 검색바 상태

  Future<void> _loadData() async {
    final eoslProvider = context.read<EoslProvider>();

    // 데이터 로드
    await eoslProvider.getEoslList();
    await eoslProvider.getEoslDetailList();
  }

  void _filterTasks(DateTimeRange range) {
    setState(() {
      selectedDateRange = range;
      currentPage = 1; // 필터 적용 시 첫 페이지로 리셋
    });
  }

  void _searchTasks(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // 검색어를 소문자로 변환
      currentPage = 1; // 첫 페이지로 리셋
    });
  }

  // void _toggleSearchBar() {
  //   setState(() {
  //     isSearchFolded = !isSearchFolded;
  //   });
  // }

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

          // 필터링된 TaskCard만 보이도록 설정
          final filteredTasks =
              _getFilteredTasks(selectedDateRange, searchQuery);

          // 페이지 수 계산
          final totalPages =
              (filteredTasks.length / itemsPerPage).ceil(); // 총 페이지 수 계산

          // 현재 페이지에 맞는 TaskCard 가져오기
          final visibleTasks = filteredTasks
              .skip((currentPage - 1) * itemsPerPage)
              .take(itemsPerPage)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EoslInfoWidget(eoslDetailModel: eoslDetailModel),
              const SizedBox(height: 16),
              // Center(
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.5, // 화면의 1/3 크기
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: TextField(
              //             decoration: InputDecoration(
              //               prefixIcon: const Icon(Icons.search),
              //               labelText: "검색",
              //               hintText: "Task 제목 또는 설명 검색",
              //               border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //             ),
              //             onSubmitted: _searchTasks,
              //           ),
              //         ),
              //         const SizedBox(width: 8),
              //         ElevatedButton(
              //           onPressed: () {
              //             _searchTasks(searchQuery); // 검색 버튼 클릭 시 검색 수행
              //           },
              //           child: const Text("검색"),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Center(
                child: AnimatedSearchBar(
                  // folded: isSearchFolded,
                  onSearch: _searchTasks,
                  // onFoldChange: _toggleSearchBar,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    // border: Border.all(),
                    // gradient: LinearGradient(
                    //   colors: [Colors.teal.shade100, Colors.teal.shade300],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    borderRadius: BorderRadius.circular(16),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.teal.withOpacity(0.3),
                    //     spreadRadius: 2,
                    //     blurRadius: 8,
                    //     offset: const Offset(0, 4),
                    //   ),
                    // ],
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
                    // itemCount: 10, // 유지보수 이력 개수
                    // itemCount: filteredTasks.length,
                    itemCount: visibleTasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskIndex: visibleTasks[index],
                        onTap: () {
                          // 작업 상세보기 로직
                          context.go(
                            '/mainnavi/eosl_list/eosl_detail/${widget.hostName}/history?taskIndex=$index',
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // 페이지 네비게이션 버튼 추가
              if (totalPages > 1)
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
                              }
                            : null,
                      ),
                      Text('Page $currentPage of $totalPages'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: currentPage < totalPages
                            ? () {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            : null,
                      ),
                    ],
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

  // 선택된 날짜 범위와 검색어에 맞는 TaskCard 필터링
  List<int> _getFilteredTasks(DateTimeRange range, String query) {
    // 필터링 로직 (예시 데이터를 사용하여 taskIndex와 텍스트로 필터링)
    final tasks = List.generate(10, (index) {
      final taskDate = DateTime.now().add(Duration(days: index)); // 예시 데이터
      final taskTitle = 'Task Title #$index'.toLowerCase(); // 예시 데이터, 소문자로 변환
      final taskDescription =
          'Task Description #$index'.toLowerCase(); // 예시 데이터, 소문자로 변환

      // 날짜 필터링 및 검색어 필터링 적용
      if (taskDate.isAfter(range.start) &&
          taskDate.isBefore(range.end) &&
          (taskTitle.contains(query.toLowerCase()) ||
              taskDescription.contains(query.toLowerCase()))) {
        return index;
      } else {
        return -1; // 필터링 조건에 맞지 않으면 -1로 표시
      }
    }).where((index) => index != -1).toList();

    return tasks;
  }
}
