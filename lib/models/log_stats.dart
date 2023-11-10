import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/helpers/datetime_helpers.dart';

class LogStats {
  final DateTime? startDate;
  final int totalSessions;

  /// In minutes
  final double averageDuration;

  /// In minutes
  final int totalDuration;
  final double averageFocus;
  final double averageProgress;
  final double averageSatisfaction;

  LogStats({
    required this.startDate,
    required this.totalSessions,
    required this.averageDuration,
    required this.totalDuration,
    required this.averageFocus,
    required this.averageProgress,
    required this.averageSatisfaction,
  });

  LogStats.empty()
      : startDate = null,
        totalSessions = 0,
        totalDuration = 0,
        averageDuration = 0.0,
        averageFocus = 0.0,
        averageProgress = 0.0,
        averageSatisfaction = 0.0;

  /// Will return a `LogStats` object with all the statistics data
  /// calculated for `logs`
  ///
  /// Returns an empty `LogStats` if there are no logs
  static LogStats fromLogs(List<Log> logs) {
    if (logs.isEmpty) {
      return LogStats.empty();
    }

    int nSessions = 0;
    int totalFocus = 0;
    int nFocus = 0;
    int totalProgress = 0;
    int nProgress = 0;
    int totalSatisfaction = 0;
    int nSatisfaction = 0;
    int totalDuration = 0;
    DateTime? earliestDate;
    for (Log log in logs) {
      nSessions++;
      if (earliestDate == null || log.dateTime.isBefore(earliestDate)) {
        earliestDate = log.dateTime;
      }
      totalDuration += log.durationInMin ?? 0;
      if (log.focus != null) {
        totalFocus += log.focus!;
        nFocus++;
      }
      if (log.progress != null) {
        totalProgress += log.progress!;
        nProgress++;
      }
      if (log.satisfaction != null) {
        totalSatisfaction += log.satisfaction!;
        nSatisfaction++;
      }
    }
    return LogStats(
      startDate: earliestDate,
      totalSessions: nSessions,
      averageDuration: nSessions == 0 ? 0 : totalDuration / nSessions,
      totalDuration: totalDuration,
      averageFocus: nFocus == 0 ? 0 : totalFocus / nFocus,
      averageProgress: nProgress == 0 ? 0 : totalProgress / nProgress,
      averageSatisfaction:
          nSatisfaction == 0 ? 0 : totalSatisfaction / nSatisfaction,
    );
  }

  String _roundedString(double data) =>
      data == 0.0 ? '-' : data.toStringAsFixed(1);

  // Get functions
  String get averageDurationAsString => _roundedString(averageDuration);
  String get averageFocusAsString => _roundedString(averageFocus);
  String get averageProgressAsString => _roundedString(averageProgress);
  String get averageSatisfactionAsString => _roundedString(averageSatisfaction);
  String get daysSinceLearningAsString =>
      startDate?.numberOfDaysBetween(DateTime.now()).toString() ?? '-';
  String get totalDurationInHours => (totalDuration / 60).toStringAsFixed(1);
}
