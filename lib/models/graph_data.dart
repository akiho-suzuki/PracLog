class RatingsGraphData {
  final List<double?> focusRatings;
  final List<double?> satisfactionRatings;
  final List<double?> progressRatings;

  RatingsGraphData({
    required this.focusRatings,
    required this.progressRatings,
    required this.satisfactionRatings,
  });
}

class DurationGraphData {
  final List<double> dayTotals;
  final List<List<int>> dayData;

  DurationGraphData({required this.dayData, required this.dayTotals});

  double maxDayTotal() {
    double max = 0.0;
    for (double value in dayTotals) {
      if (value > max) {
        max = value;
      }
    }
    return max;
  }
}

class StatsSummaryData {
  final String focus;
  final String progress;
  final String satisfaction;
  final String averageDuration;
  final String totalDuration;
  final String nSessions;

  StatsSummaryData({
    required this.focus,
    required this.progress,
    required this.satisfaction,
    required this.averageDuration,
    required this.totalDuration,
    required this.nSessions,
  });
}
