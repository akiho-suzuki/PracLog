import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/graph_data.dart';
import 'package:praclog/models/log.dart';
import '../helpers/datetime_helpers.dart';

enum GraphDateType { last7Days, last28Days }

/// A class for holding the data for specific attributes for weekData (e.g. focus). Allows access to aggregate data like daily averages, weekly total, etc.
class _WeekDataTemplate {
  final List<int> mon;
  final List<int> tue;
  final List<int> wed;
  final List<int> thu;
  final List<int> fri;
  final List<int> sat;
  final List<int> sun;

  _WeekDataTemplate({
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });

  List<int> get _combinedList => mon + tue + wed + thu + fri + sat + sun;

  _WeekDataTemplate.empty()
      : this(
          mon: [],
          tue: [],
          wed: [],
          thu: [],
          fri: [],
          sat: [],
          sun: [],
        );

  Map<String, List<int>> toJson() {
    return {
      WeekData.mon: mon,
      WeekData.tue: tue,
      WeekData.wed: wed,
      WeekData.thu: thu,
      WeekData.fri: fri,
      WeekData.sat: sat,
      WeekData.sun: sun,
    };
  }

  _WeekDataTemplate.fromJson(Map<String, dynamic> jsonMap)
      : this(
          mon: List<int>.from(jsonMap[WeekData.mon]! as List),
          tue: List<int>.from(jsonMap[WeekData.tue]! as List),
          wed: List<int>.from(jsonMap[WeekData.wed]! as List),
          thu: List<int>.from(jsonMap[WeekData.thu]! as List),
          fri: List<int>.from(jsonMap[WeekData.fri]! as List),
          sat: List<int>.from(jsonMap[WeekData.sat]! as List),
          sun: List<int>.from(jsonMap[WeekData.sun]! as List),
        );

  double _getDailyAverage(List<int> dayData) {
    if (dayData.isEmpty) {
      return 0;
    } else {
      int total = 0; // total score
      int n = 0; // no. of sessions where score was given
      for (int score in dayData) {
        if (score != 0) {
          n++;
          total += score;
        }
      }
      return n == 0 ? 0 : total / n;
    }
  }

  double _getDailyTotal(List<int> dayData) {
    if (dayData.isEmpty) {
      return 0;
    } else {
      double total = 0;
      for (int score in dayData) {
        total += score;
      }
      return total;
    }
  }

  double get monTotal => _getDailyTotal(mon);
  double get tueTotal => _getDailyTotal(tue);
  double get wedTotal => _getDailyTotal(wed);
  double get thuTotal => _getDailyTotal(thu);
  double get friTotal => _getDailyTotal(fri);
  double get satTotal => _getDailyTotal(sat);
  double get sunTotal => _getDailyTotal(sun);

  /// For duration
  String get weekTotal => _getDailyTotal(_combinedList).toStringAsFixed(1);

  /// Converts from minutes to hours (only use for duration)
  String get weekTotalInHours =>
      (_getDailyTotal(_combinedList) / 60).toStringAsFixed(1);

  /// Returns a list containing lists of data for each day
  List<List<int>> get dayDataList {
    return [mon, tue, wed, thu, fri, sat, sun];
  }

  /// Return a list containing total for each day
  List<double> get dayTotal {
    return [
      monTotal,
      tueTotal,
      wedTotal,
      thuTotal,
      friTotal,
      satTotal,
      sunTotal
    ];
  }

  /// Returns a list with average for each day of the week
  List<double> get averageList {
    List<double> newList = [];
    newList.add(_getDailyAverage(mon));
    newList.add(_getDailyAverage(tue));
    newList.add(_getDailyAverage(wed));
    newList.add(_getDailyAverage(thu));
    newList.add(_getDailyAverage(fri));
    newList.add(_getDailyAverage(sat));
    newList.add(_getDailyAverage(sun));
    return newList;
  }

  /// Returns an overall average for the week. If there are no scores for the week, returns '-'
  String get weekAverage {
    int total = 0;
    int n = 0;
    for (int score in _combinedList) {
      if (score != 0) {
        total += score;
        n++;
      }
    }
    if (n != 0) {
      return (total / n).toStringAsFixed(1);
    } else {
      return '-';
    }
  }

  /// Updates the data.
  /// Note that the newData cannot be null; this check must be conducted before invoking this function
  void update(String day, int newData) {
    try {
      if (day == WeekData.mon) {
        mon.add(newData);
      } else if (day == WeekData.tue) {
        tue.add(newData);
      } else if (day == WeekData.wed) {
        wed.add(newData);
      } else if (day == WeekData.thu) {
        thu.add(newData);
      } else if (day == WeekData.fri) {
        fri.add(newData);
      } else if (day == WeekData.sat) {
        sat.add(newData);
      } else if (day == WeekData.sun) {
        sun.add(newData);
      } else {
        throw Exception('Invalid day');
      }
    } catch (e) {
      print(e);
    }
  }

  /// Reverse updates (for when log is deleted)
  void reverseUpdate(String day, int dataToRemove) {
    // The result will become false if the data does not exist
    bool result = true;
    if (day == WeekData.mon) {
      result = mon.remove(dataToRemove);
    } else if (day == WeekData.tue) {
      result = tue.remove(dataToRemove);
    } else if (day == WeekData.wed) {
      result = wed.remove(dataToRemove);
    } else if (day == WeekData.thu) {
      result = thu.remove(dataToRemove);
    } else if (day == WeekData.fri) {
      result = fri.remove(dataToRemove);
    } else if (day == WeekData.sat) {
      result = sat.remove(dataToRemove);
    } else if (day == WeekData.sun) {
      result = sun.remove(dataToRemove);
    } else {
      throw Exception('Invalid day');
    }
    if (result == false) {
      throw Exception('Data not found');
    }
  }
}

class WeekData {
  // Static strings for Firestore map keys
  static const String mon = 'mon';
  static String tue = 'tue';
  static String wed = 'wed';
  static String thu = 'thu';
  static String fri = 'fri';
  static String sat = 'sat';
  static String sun = 'sun';
  static List<String> weekList = [mon, tue, wed, thu, fri, sat, sun];

  // ID from Firestore
  final String? id;

  /// The date at which the week starts (Week starts on Monday)
  final DateTime weekStartDate;

  /// A map with number of practice sessions for each day of the week (mon - sun)
  final Map<String, int> nSessionsList;

  // Contains ratings/durations for each day (mon - sun)
  final _WeekDataTemplate focusList;
  final _WeekDataTemplate progressList;
  final _WeekDataTemplate satisfactionList;
  final _WeekDataTemplate durationsList;

  WeekData(
      {required DateTime weekStartDateUnformatted,
      this.id,
      required this.nSessionsList,
      required this.focusList,
      required this.progressList,
      required this.satisfactionList,
      required this.durationsList})
      : weekStartDate = weekStartDateUnformatted.setAtStartOfDay(),
        // Week start date must be a monday
        assert(weekStartDateUnformatted.weekday == DateTime.monday),
        // N Session List must be of length 7 with the days of the week
        assert(nSessionsList.length == 7),
        assert(nSessionsList.containsKey(mon)),
        assert(nSessionsList.containsKey(tue)),
        assert(nSessionsList.containsKey(wed)),
        assert(nSessionsList.containsKey(thu)),
        assert(nSessionsList.containsKey(fri)),
        assert(nSessionsList.containsKey(sat)),
        assert(nSessionsList.containsKey(sun));

// Generates a map (where key is day and value is nSessions) with 0 nSessions for each day
  static Map<String, int> _generateEmptyNSessionsList() {
    Map<String, int> map = {};
    for (int i = 0; i < 7; i++) {
      map[weekList[i]] = 0;
    }
    return map;
  }

// Generates a WeeklySummaryStats with no data
  WeekData.emptyStats({required DateTime weekStartDate, String? id})
      : this(
            id: id,
            weekStartDateUnformatted: weekStartDate,
            nSessionsList: _generateEmptyNSessionsList(),
            focusList: _WeekDataTemplate.empty(),
            progressList: _WeekDataTemplate.empty(),
            satisfactionList: _WeekDataTemplate.empty(),
            durationsList: _WeekDataTemplate.empty());

// To convert data from Firestore
  WeekData.fromJson(String id, Map<String, Object?> json)
      : this(
          id: id,
          weekStartDateUnformatted:
              DateTime.parse(json[Label.weekStartDate] as String),
          satisfactionList: _WeekDataTemplate.fromJson(
              json[Label.satisfactionList] as Map<String, dynamic>),
          progressList: _WeekDataTemplate.fromJson(
              json[Label.progressList] as Map<String, dynamic>),
          focusList: _WeekDataTemplate.fromJson(
              json[Label.focusList] as Map<String, dynamic>),
          durationsList: _WeekDataTemplate.fromJson(
              json[Label.durationsList] as Map<String, dynamic>),
          nSessionsList: Map<String, int>.from(
              json[Label.nSessionsList] as Map<String, dynamic>),
        );

// To convert data to Firestore
  Map<String, Object?> toJson() {
    return {
      Label.nSessionsList: nSessionsList,
      // WeekStartDate is stored as a string of format '2022-05-02' in firestore
      Label.weekStartDate: weekStartDate.getDateOnly(),
      Label.satisfactionList: satisfactionList.toJson(),
      Label.progressList: progressList.toJson(),
      Label.focusList: focusList.toJson(),
      Label.durationsList: durationsList.toJson(),
    };
  }

  /// Returns total number of sessions for the week
  int get totalNSessions {
    int total = 0;
    nSessionsList.forEach((_, value) {
      total += value;
    });
    return total;
  }

// Updates the week data according to the new log
  void update(Log log, {bool reverseUpdate = false}) {
    // Check it's the correct week
    int n = weekStartDate.numberOfDaysBetween(log.date);
    if (n > 6) {
      String errorMsg =
          'Log does not belong to this weekData. Log date: ${log.date}. WeekData for week starting on: $weekStartDate';
      throw ArgumentError.value(log, errorMsg);
    } else {
      // Identify the day of the week
      String day = weekList[n];

      // Update nSessions
      nSessionsList[day] =
          reverseUpdate ? nSessionsList[day]! - 1 : nSessionsList[day]! + 1;

      // Update duration
      reverseUpdate
          ? durationsList.reverseUpdate(day, log.durationInMin)
          : durationsList.update(day, log.durationInMin);

      // Update ratings
      reverseUpdate
          ? focusList.reverseUpdate(day, log.focus ?? 0)
          : focusList.update(day, log.focus ?? 0);

      reverseUpdate
          ? satisfactionList.reverseUpdate(day, log.satisfaction ?? 0)
          : satisfactionList.update(day, log.satisfaction ?? 0);

      reverseUpdate
          ? progressList.reverseUpdate(day, log.progress ?? 0)
          : progressList.update(day, log.progress ?? 0);
    }
  }

  static void _dataCheck(List<WeekData> data, int day, GraphDateType type) {
    // Check that the data (List<WeekData>) is of expected length
    // If it's for a sunday
    if (day == DateTime.sunday) {
      if ((type == GraphDateType.last28Days && data.length != 4) ||
          (type == GraphDateType.last7Days && data.length != 1)) {
        throw ArgumentError(
            'Data length is wrong. For Sunday, length must be ${type == GraphDateType.last28Days ? '4' : '1'}. Actual length: ${data.length}');
      }
    } else {
      if ((type == GraphDateType.last28Days && data.length != 5) ||
          (type == GraphDateType.last7Days && data.length != 2)) {
        throw ArgumentError(
            'Data length is wrong. Length must be ${type == GraphDateType.last28Days ? '5' : '2'}. Actual length: ${data.length}');
      }
    }
  }

  // Takes a list of `WeekData` and turns it into `DurationGraphData`, as appropriate to the specified `GraphDateType` (e.g. last 7 days, last 28 days)
  static DurationGraphData generateDurationGraphData(
      List<WeekData> data, int day, GraphDateType type) {
    _dataCheck(data, day, type);
    List<double> dayTotals = [];
    List<List<int>> dayData = [];

    // If it's not sunday, just add the entire data
    if (day == 7) {
      for (WeekData weekData in data) {
        dayTotals += weekData.durationsList.dayTotal;
        dayData += weekData.durationsList.dayDataList;
      }
    } else {
      // Add the data for first week (e.g. if it's a Fri, add Sat and Sun)
      WeekData weekOne = data[0];
      dayTotals += weekOne.durationsList.dayTotal.sublist(day);
      dayData += weekOne.durationsList.dayDataList.sublist(day);

      // Do middle weeks (not necessarily for last 7 days data)
      if (type == GraphDateType.last28Days) {
        List<WeekData> middleWeeks = data.sublist(1, 4);
        for (WeekData weekData in middleWeeks) {
          dayTotals += weekData.durationsList.dayTotal;
          dayData += weekData.durationsList.dayDataList;
        }
      }

      // Do the current week (e.g. if it's a Fri, add Mon-Fri)
      WeekData currentWeek = data.last;
      dayTotals += currentWeek.durationsList.dayTotal.sublist(0, day);
      dayData += currentWeek.durationsList.dayDataList.sublist(0, day);
    }

    return DurationGraphData(dayData: dayData, dayTotals: dayTotals);
  }

  // Takes a list of `WeekData` and turns it into `RatingsGraphData`, as appropriate to the specified `GraphDateType` (e.g. last 7 days, last 28 days)
  static RatingsGraphData generateRatingsGraphData(
      List<WeekData> data, int day, GraphDateType type) {
    _dataCheck(data, day, type);

    List<double?> focusRatings = [];
    List<double?> satisfactionRatings = [];
    List<double?> progressRatings = [];

    // If it's not sunday, just add the entire data
    if (day == 7) {
      for (WeekData weekData in data) {
        focusRatings += weekData.focusList.averageList;
        progressRatings += weekData.progressList.averageList;
        satisfactionRatings += weekData.satisfactionList.averageList;
      }
    } else {
      // Add the data for first week (e.g. if it's a Fri, add Sat and Sun)
      WeekData weekOne = data[0];
      focusRatings += weekOne.focusList.averageList.sublist(day);
      progressRatings += weekOne.progressList.averageList.sublist(day);
      satisfactionRatings += weekOne.satisfactionList.averageList.sublist(day);

      // Do middle weeks (not necessarily for 7 day data)
      if (type == GraphDateType.last28Days) {
        List<WeekData> middleWeeks = data.sublist(1, 4);
        for (WeekData weekData in middleWeeks) {
          focusRatings += weekData.focusList.averageList;
          progressRatings += weekData.progressList.averageList;
          satisfactionRatings += weekData.satisfactionList.averageList;
        }
      }

      // Do the current week (e.g. if it's a Fri, add Mon-Fri)
      WeekData currentWeek = data.last;
      focusRatings += currentWeek.focusList.averageList.sublist(0, day);
      progressRatings += currentWeek.progressList.averageList.sublist(0, day);
      satisfactionRatings +=
          currentWeek.satisfactionList.averageList.sublist(0, day);
    }

    return RatingsGraphData(
        focusRatings: focusRatings,
        progressRatings: progressRatings,
        satisfactionRatings: satisfactionRatings);
  }

  /// Set day = 7 in order to get stats for this calendar week (Mon - Sun) rather than the last 7 days.
  static StatsSummaryData generateLast7DaysStatsSummaryData(
      List<WeekData> data, int day) {
    if (day == 7) {
      WeekData weekData = data.last;
      return StatsSummaryData(
          focus: weekData.focusList.weekAverage,
          progress: weekData.progressList.weekAverage,
          satisfaction: weekData.satisfactionList.weekAverage,
          averageDuration: weekData.durationsList.weekAverage,
          totalDuration: weekData.durationsList.weekTotalInHours,
          nSessions: weekData.totalNSessions.toString());
    } else {
      WeekData week1 = data.first;
      WeekData week2 = data.last;
      List<_WeekDataTemplate> focusData = [week1.focusList, week2.focusList];
      List<_WeekDataTemplate> progressData = [
        week1.progressList,
        week2.progressList
      ];
      List<_WeekDataTemplate> satisfactionData = [
        week1.satisfactionList,
        week2.satisfactionList
      ];
      List<_WeekDataTemplate> durationData = [
        week1.durationsList,
        week2.durationsList
      ];

      List<List<_WeekDataTemplate>> dataList = [
        focusData,
        progressData,
        satisfactionData,
        durationData
      ];
      List<_WeekDataTemplate> newDataList = [];

      for (List<_WeekDataTemplate> data in dataList) {
        _WeekDataTemplate newData = _WeekDataTemplate(
          // Mon has to be from Week 2
          mon: data.last.mon,
          tue: day < 2 ? data.first.tue : data.last.tue,
          wed: day < 3 ? data.first.wed : data.last.wed,
          thu: day < 4 ? data.first.thu : data.last.thu,
          fri: day < 5 ? data.first.fri : data.last.fri,
          sat: day < 6 ? data.first.sat : data.last.sat,
          // Sun has to be from Week 1
          sun: data.first.sun,
        );
        newDataList.add(newData);
      }

      double totalNSessions = 0;
      // Monday has to be from Week 2
      totalNSessions += week2.nSessionsList[mon]!;
      totalNSessions +=
          day < 2 ? week1.nSessionsList[tue]! : week2.nSessionsList[tue]!;
      totalNSessions +=
          day < 3 ? week1.nSessionsList[wed]! : week2.nSessionsList[wed]!;
      totalNSessions +=
          day < 4 ? week1.nSessionsList[thu]! : week2.nSessionsList[thu]!;
      totalNSessions +=
          day < 5 ? week1.nSessionsList[fri]! : week2.nSessionsList[fri]!;
      totalNSessions +=
          day < 6 ? week1.nSessionsList[sat]! : week2.nSessionsList[sat]!;
      // Sunday has to be from Week 1
      totalNSessions += week1.nSessionsList[sun]!;

      return StatsSummaryData(
        focus: newDataList[0].weekAverage,
        progress: newDataList[1].weekAverage,
        satisfaction: newDataList[2].weekAverage,
        averageDuration: newDataList[3].weekAverage,
        totalDuration: newDataList[3].weekTotalInHours,
        nSessions: totalNSessions.round().toString(),
      );
    }
  }
}
