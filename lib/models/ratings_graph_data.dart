import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/helpers/datetime_helpers.dart';

class GraphData {
  List<double?> focusRatings;
  List<double?> satisfactionRatings;
  List<double?> progressRatings;
  List<List<int>> dayDurationData;

  // These are to keep track of ratings for each day before averaging
  int _focusTotal;
  int _nFocus;
  int _progressTotal;
  int _nProgress;
  int _satisfactionTotal;
  int _nSatisfaction;
  List<int> _durations;

  GraphData({
    required this.focusRatings,
    required this.progressRatings,
    required this.satisfactionRatings,
    required this.dayDurationData,
  })  : _focusTotal = 0,
        _nFocus = 0,
        _progressTotal = 0,
        _nProgress = 0,
        _satisfactionTotal = 0,
        _nSatisfaction = 0,
        _durations = [];

  static GraphData empty() => GraphData(
      focusRatings: [],
      progressRatings: [],
      satisfactionRatings: [],
      dayDurationData: []);

  /// Returns a list of total practice duration for each day
  List<double> get dayTotals {
    List<double> dayTotals = [];
    for (List<int> dayList in dayDurationData) {
      double dayTotal = 0;
      for (int sessionDuration in dayList) {
        dayTotal += sessionDuration;
      }
      dayTotals.add(dayTotal);
    }
    return dayTotals;
  }

  /// Finds the duration of the day with highest total duration
  double maxDayTotal() {
    double max = 0.0;
    for (double value in dayTotals) {
      if (value > max) {
        max = value;
      }
    }
    return max;
  }

  void _addEmptyData(int nDays) {
    for (int i = 0; i < nDays; i++) {
      focusRatings.add(0.0);
      satisfactionRatings.add(0.0);
      progressRatings.add(0.0);
      dayDurationData.add([]);
    }
  }

  void _calculateRatingsAverage() {
    focusRatings.add(_nFocus == 0 ? 0 : _focusTotal / _nFocus);
    satisfactionRatings
        .add(_nSatisfaction == 0 ? 0 : _satisfactionTotal / _nSatisfaction);
    progressRatings.add(_nProgress == 0 ? 0 : _progressTotal / _nProgress);
    dayDurationData.add(_durations);

    // Reset the counts
    _focusTotal = 0;
    _nFocus = 0;
    _progressTotal = 0;
    _nProgress = 0;
    _satisfactionTotal = 0;
    _nSatisfaction = 0;
    _durations = [];
  }

  void _addLogRatings(Log log) {
    if (log.durationInMin != null) {
      _durations.add(log.durationInMin!);
    }
    if (log.focus != null) {
      _focusTotal += log.focus!;
      _nFocus++;
    }
    if (log.progress != null) {
      _progressTotal += log.progress!;
      _nProgress++;
    }
    if (log.satisfaction != null) {
      _satisfactionTotal += log.satisfaction!;
      _nSatisfaction++;
    }
  }

  /// `logs` need to be sorted in ascending order of `dateTime` (i.e. oldest to newest)
  static GraphData getRatingsGraphData(
      List<Log> logs, DateTime startDate, DateTime endDate) {
    // Set start and end dates at start of the day
    startDate = startDate.setAtStartOfDay();
    endDate = endDate.setAtStartOfDay();

    if (startDate.isAfter(endDate)) {
      throw ArgumentError(["startDate must not be after endDate"]);
    }

    final GraphData ratingsGraphData = GraphData.empty();

    // If logs is empty, return a empty data for period
    if (logs.isEmpty) {
      int nDays = startDate.numberOfDaysBetween(endDate);
      ratingsGraphData._addEmptyData(nDays + 1);
      return ratingsGraphData;
    }

    // If the date of the first log is after the startDate, then add empty data until the first log
    int startDiff =
        startDate.numberOfDaysBetween(logs.first.dateTime.setAtStartOfDay());
    if (startDiff != 0) {
      ratingsGraphData._addEmptyData(startDiff);
    }

    // Add ratings from first log
    ratingsGraphData._addLogRatings(logs.first);

    // Set currentDate to first log date
    DateTime currentDate = logs.first.dateTime.setAtStartOfDay();

    // Loop through all other logs (i.e. all logs except the first)
    for (int i = 1; i < logs.length; i++) {
      Log log = logs[i];
      DateTime logDate = log.dateTime.setAtStartOfDay();
      int dateDiff = currentDate.numberOfDaysBetween(logDate);

// Case 1: The log is the first for currentDate (currentDate is the day before)
      if (dateDiff == 1) {
        // Calculate the average of the day before
        ratingsGraphData._calculateRatingsAverage();
        //  Add the ratings from this log to the total
        ratingsGraphData._addLogRatings(log);
        // Set currentDate to date of this log
        currentDate = logDate;
// Case 2: The log is not the first for currentDate
      } else if (dateDiff == 0) {
        //  Add the ratings from this log to the total
        ratingsGraphData._addLogRatings(log);

// Case 3: Date/s have been skipped (log is 2+ days after currentDate)
      } else {
        // Calculate the average of the last day with a log
        ratingsGraphData._calculateRatingsAverage();

        // Add empty data for days between last log and this log
        ratingsGraphData._addEmptyData(dateDiff - 1);

        //  Add the ratings from this log to the total
        ratingsGraphData._addLogRatings(log);

        // Set currentDate as the log date
        currentDate = logDate;
      }
    }

    // Calculate the average of the last day
    ratingsGraphData._calculateRatingsAverage();

    // Check to see if the average lists have been filled to endDate.
    // If not fill the rest of the days with empty data
    if (logs.last.dateTime.setAtStartOfDay() != endDate) {
      int diff = logs.last.dateTime.numberOfDaysBetween(endDate);
      ratingsGraphData._addEmptyData(diff);
    }

    return ratingsGraphData;
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
