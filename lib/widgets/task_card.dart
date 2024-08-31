// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class TaskCard extends StatelessWidget {
//   final int taskIndex;
//   final VoidCallback onTap;

//   const TaskCard({
//     super.key,
//     required this.taskIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // 길이 조절
//         final cardWidth = constraints.maxWidth; // 길이
//         const cardHeight = 300.0; // 높이

//         return GestureDetector(
//           onTap: onTap,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             width: cardWidth,
//             height: cardHeight,
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.white, Colors.grey.shade200],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 2,
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Task Title #$taskIndex',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.teal.shade800,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Task Description #$taskIndex',
//                     style: const TextStyle(fontSize: 14, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: taskIndex)))}',
//                     // 'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task; // Task 데이터 받기
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Task 데이터에서 필요한 필드 추출
    final taskContent = task['content'] ?? 'No content';
    final taskNotes = task['notes'] ?? 'No notes';
    final taskDate = task['date'] != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task['date']))
        : 'No date';

    return LayoutBuilder(
      builder: (context, constraints) {
        // 길이 조절
        final cardWidth = constraints.maxWidth; // 길이
        const cardHeight = 300.0; // 높이

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskContent,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    taskNotes,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: $taskDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
