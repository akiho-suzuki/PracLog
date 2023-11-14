import 'package:flutter/material.dart';

class LogsDeleteManager extends ChangeNotifier {
  final List<int> logIds = [];
  bool on = false;

  void add(int logId) {
    logIds.add(logId);
    notifyListeners();
  }

  void remove(int logId) {
    logIds.remove(logId);
    if (logIds.isEmpty) {
      on = false;
    }
    notifyListeners();
  }

  void clear() {
    logIds.clear();
    notifyListeners();
  }

  void turnOn() {
    on = true;
    notifyListeners();
  }

  void turnOff() {
    on = false;
    notifyListeners();
  }
}
