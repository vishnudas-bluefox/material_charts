import 'package:flutter/material.dart';
import 'package:material_charts/src/gantt_chart/models.dart';

class GanttDateUtils {
  static DateTimeRange getTimeRange(List<GanttData> data) {
    DateTime? earliest;
    DateTime? latest;

    for (final point in data) {
      if (earliest == null || point.startDate.isBefore(earliest)) {
        earliest = point.startDate;
      }
      if (latest == null || point.endDate.isAfter(latest)) {
        latest = point.endDate;
      }
    }

    return DateTimeRange(
      start: earliest!.subtract(const Duration(days: 7)),
      end: latest!.add(const Duration(days: 7)),
    );
  }
}
