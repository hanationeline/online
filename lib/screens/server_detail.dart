// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:oneline/models/server_model.dart';
// import 'package:intl/intl.dart';
// import 'package:oneline/widgets/server_info_widget.dart';
// import 'package:oneline/widgets/task_card.dart';
// import 'package:oneline/models/server_provider.dart';
// import 'package:provider/provider.dart';

// class ServerDetailPage extends StatefulWidget {
//   final String serverNo;

//   const ServerDetailPage({
//     super.key,
//     required this.serverNo,
//   });

//   @override
//   _ServerDetailPageState createState() => _ServerDetailPageState();
// }

// class _ServerDetailPageState extends State<ServerDetailPage> {
//   Future<void> _fetchServerData() async {
//     final serverProvider = context.read<ServerProvider>();
//     await serverProvider.fetchServers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('서버 상세 정보'),
//         backgroundColor: Colors.teal,
//       ),
//       body: FutureBuilder<void>(
//         future: _fetchServerData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('서버 데이터를 불러오는 중 오류가 발생했습니다.'));
//           }

//           final serverProvider = context.read<ServerProvider>();
//           final server = serverProvider.getServerByNo(widget.serverNo);

//           if (server == null) {
//             return const Center(child: Text('서버 정보를 불러오지 못했습니다.'));
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ServerInfoWidget(
//                 server: server,
//                 onCalendarPressed: () {
//                   // TODO: EOSL 날짜를 캘린더에 등록하는 로직 추가
//                 },
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final DateTimeRange? picked =
//                               await showDateRangePicker(
//                             context: context,
//                             initialDateRange: null,
//                             firstDate: DateTime(2000),
//                             lastDate: DateTime(2101),
//                           );
//                           if (picked != null) {
//                             setState(() {
//                               // 선택된 날짜 범위 처리
//                             });
//                           }
//                         },
//                         child: const Text('기간 선택'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       childAspectRatio:
//                           (MediaQuery.of(context).size.width / 3 - 20) / 300,
//                     ),
//                     itemCount: 10,
//                     itemBuilder: (context, index) {
//                       return TaskCard(
//                         taskIndex: index,
//                         onTap: () {
//                           context.go(
//                             '/mainnavi/server_list/server_detail/${widget.serverNo}/history?taskIndex=$index',
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
