import 'package:flutter/material.dart';
import 'package:praclog_v2/collections/log.dart';

class TimerDataManager extends ChangeNotifier {
  final List<TimerData> _timerDataList = [];
  List<TimerData> get timerDataList => _timerDataList;

  set setTimerDataList(List<TimerData> timerDataList) {
    for (TimerData timerData in timerDataList) {
      _timerDataList.add(timerData);
    }
  }

  // Start timer
  void startTimer(DateTime startTime) {
    TimerData timerData = TimerData()..startTime = startTime;
    _timerDataList.add(timerData);
    notifyListeners();
  }

  // End timer
  void stopTimer(DateTime endTime) {
    _timerDataList.last.endTime = endTime;
    notifyListeners();
  }

  // Clear timer
  void clearTimer() {
    _timerDataList.clear();
    notifyListeners();
  }

  /// Returns `true` if timer is currently on
  bool timerOn() =>
      _timerDataList.isNotEmpty ? _timerDataList.last.endTime == null : false;

  /// Returns the current timer value in seconds
  int currentTimerValue() {
    int value = 0;
    for (TimerData timerData in _timerDataList) {
      // If timer is not running
      if (timerData.endTime != null) {
        value += timerData.endTime!.difference(timerData.startTime).inSeconds;
      } else {
        value += DateTime.now().difference(timerData.startTime).inSeconds;
      }
    }
    return value;
  }

  /// Returns timer value in minutes
  int timerMinValue() => (currentTimerValue() / 60).round();
}
