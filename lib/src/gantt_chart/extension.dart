import 'package:flutter/material.dart';
import 'package:material_charts/src/gantt_chart/models.dart';

extension GanttDataListExtension on List<GanttData> {
  List<GanttData> sortByStartDate() {
    final sorted = [...this];
    sorted.sort((a, b) => a.startDate.compareTo(b.startDate));
    return sorted;
  }

  List<GanttData> filterByDateRange(DateTimeRange range) {
    return where((item) =>
        (item.startDate.isAfter(range.start) ||
            item.startDate.isAtSameMomentAs(range.start)) &&
        (item.endDate.isBefore(range.end) ||
            item.endDate.isAtSameMomentAs(range.end))).toList();
  }

  Map<T, List<GanttData>> groupBy<T>(T Function(GanttData) keySelector) {
    final map = <T, List<GanttData>>{};
    for (final item in this) {
      final key = keySelector(item);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }
}
