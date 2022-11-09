import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:praclog/helpers/label.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds start and end times for the timer so that practice duration can be calculated
class TimerData extends ChangeNotifier {
  // A list of timer point lists. Each timer point list is in form [startTime, endTime]
  List<List<DateTime?>> _data;
  List<List<DateTime?>> get data => _data;
  TimerData(this._data);

  TimerData.empty() : this([]);

  /// Converts current `_data` to json and stores locally
  Future saveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Label.timerData, _toJson());
  }

  /// Fetches data from local storage and populates `_data`
  Future fetchData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? jsonData = sharedPreferences.getString(Label.timerData);
    if (jsonData != null) {
      _data = _decode(json.decode(jsonData) as List<dynamic>);
    }
  }

  String _toJson() {
    List<List<String?>> dateStrings = [];
    for (List<DateTime?> dateTimePair in _data) {
      List<String?> dateTimePairString = [];
      for (DateTime? dateTime in dateTimePair) {
        dateTimePairString.add(dateTime?.toIso8601String());
      }
      dateStrings.add(dateTimePairString);
    }
    return json.encode(dateStrings);
  }

  // For decode method: decodes the inner list of _data ([startTime, endTime])
  static List<DateTime?> _innerDecoder(List<dynamic> pairJsonList) {
    List<String?> list = [];
    for (dynamic date in pairJsonList) {
      list.add(date as String?);
    }
    List<DateTime?> dateList = [];
    for (String? string in list) {
      dateList.add(DateTime.tryParse(string ?? ''));
    }
    return dateList;
  }

  static List<List<DateTime?>> _decode(List<dynamic> jsonList) {
    List<List<DateTime?>> list = [];
    for (dynamic pair in jsonList) {
      list.add(_innerDecoder(pair as List<dynamic>));
    }
    return list;
  }

  void startTimer(DateTime startTime) {
    _data.add([startTime, null]);
    notifyListeners();
  }

  void stopTimer(DateTime endTime) {
    _data.last.last = endTime;
    notifyListeners();
  }

  void clear() {
    _data = [];
    notifyListeners();
  }

  /// Returns `true` if the timer is currently running and `false` if the timer is currently paused
  bool timerOn() => _data.isNotEmpty ? _data.last.last == null : false;

  /// Returns the current timer value in seconds
  int currentTimerValue() {
    int value = 0;
    for (List<DateTime?> timePairs in _data) {
      if (timePairs.last != null) {
        value += timePairs.last!.difference(timePairs.first!).inSeconds;
      } else {
        value += DateTime.now().difference(timePairs.first!).inSeconds;
      }
    }
    return value;
  }

  /// Returns timer value in minutes
  int timerMinValue() => (currentTimerValue() / 60).round();
}
