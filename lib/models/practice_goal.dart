import 'package:flutter/material.dart';
import 'package:praclog/helpers/label.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeGoal {
  final String text;
  bool isTicked;
  PracticeGoal({required this.text, this.isTicked = false});

  PracticeGoal.fromJson(List<dynamic> json)
      : this(text: json.first as String, isTicked: json.last as bool);

  List toJson() => [text, isTicked];
}

class PracticeGoalManager extends ChangeNotifier {
  List<PracticeGoal> _goalList = [];

  List<PracticeGoal>? get goalList => _goalList;

  // Writes current _goalList to json and stores on local disk
  Future saveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Label.goals, _toJson());
  }

  // Gets data from local disk and sets _goalList
  Future fetchData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? jsonData = sharedPreferences.getString(Label.goals);
    if (jsonData != null) {
      _goalList = _decode(json.decode(jsonData) as List<dynamic>);
    }
  }

  // Converts json data (`List<dynamic>`) to _goalList (`List<PracticeGoal>`)
  List<PracticeGoal> _decode(List<dynamic> json) {
    List<PracticeGoal> goals = [];
    for (dynamic item in json) {
      goals.add(PracticeGoal.fromJson(item as List<dynamic>));
    }
    return goals;
  }

  // Converts _goalList into json
  // Each goal is in the format [text, isTicked]
  String _toJson() {
    List<List> jsonList = [];
    for (PracticeGoal goal in _goalList) {
      jsonList.add(goal.toJson());
    }
    return json.encode(jsonList);
  }

  set setGoalList(List<PracticeGoal> goalList) {
    _goalList = goalList;
  }

  List<PracticeGoal>? get clonedGoalList {
    List<PracticeGoal> newList = [];
    for (PracticeGoal goal in _goalList) {
      newList.add(goal);
    }
    return newList;
  }

  int get goalListLength => _goalList.isEmpty ? 0 : _goalList.length;

  // Add goal
  void add(PracticeGoal goal) {
    _goalList.add(goal);
    notifyListeners();
  }

  // Edit goal
  void edit(PracticeGoal goal, int index) {
    _goalList[index] = goal;
    notifyListeners();
  }

  // Delete goal
  void delete(int index) {
    _goalList.removeAt(index);
    notifyListeners();
  }

  // Reorder goal
  void move(int oldIndex, int newIndex) {
    PracticeGoal removedGoal = _goalList.removeAt(oldIndex);
    _goalList.insert(newIndex, removedGoal);
    notifyListeners();
  }

  // Toggle tick status
  void toggleIsTicked(int index) {
    _goalList[index].isTicked = _goalList[index].isTicked ? false : true;
    notifyListeners();
  }

  // Delete all
  void deleteAll() {
    _goalList.clear();
    notifyListeners();
  }
}
