import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final ValueChanged<DateTimeRange> onSearch;

  const DateRangeSelector({
    super.key,
    this.initialDateRange,
    required this.onSearch,
  });

  @override
  _DateRangeSelectorState createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    selectedDateRange = widget.initialDateRange;
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateRange?.start ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = DateTimeRange(
          start: picked,
          end: selectedDateRange?.end ?? picked,
        );
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateRange?.end ?? DateTime.now(),
      firstDate: selectedDateRange?.start ?? DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = DateTimeRange(
          start: selectedDateRange?.start ?? picked,
          end: picked,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 시작 날짜 선택 필드
        Expanded(
          child: GestureDetector(
            onTap: () => _selectStartDate(context),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: selectedDateRange?.start != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(selectedDateRange!.start)
                          : '시작 날짜',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 끝 날짜 선택 필드
        Expanded(
          child: GestureDetector(
            onTap: () => _selectEndDate(context),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: selectedDateRange?.end != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(selectedDateRange!.end)
                          : '종료 날짜',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

      ],
    );
  }
}
