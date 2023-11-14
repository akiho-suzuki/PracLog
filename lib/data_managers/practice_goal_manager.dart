import 'package:flutter/material.dart';
import 'package:praclog_v2/collections/log.dart';

class PracticeGoalManager extends ChangeNotifier {
  final List<PracticeGoal> _goalList = [];
  List<PracticeGoal> get goalList => _goalList;
  int get goalListLength => _goalList.isEmpty ? 0 : _goalList.length;

  set setGoalList(List<PracticeGoal> goalList) {
    for (PracticeGoal goal in goalList) {
      _goalList.add(goal);
    }
  }

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
