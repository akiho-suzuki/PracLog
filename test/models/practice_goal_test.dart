import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../test_data.dart';

void main() {
  late PracticeGoalManager goalsManager;

  setUp(() {
    goalsManager = PracticeGoalManager();
  });

  test('Adds a goal', () {
    goalsManager.add(testGoal1);
    expect(goalsManager.goalListLength, 1);
    expect(goalsManager.goalList![0].text, equals(testGoal1Text));
  });

  test('Deletes a goal', () {
    goalsManager.add(testGoal1);
    expect(goalsManager.goalListLength, 1);
    goalsManager.delete(0);
    expect(goalsManager.goalListLength, 0);
  });

  test('Edits a goal', () {
    goalsManager.add(testGoal1);
    expect(goalsManager.goalList!.first.text, equals(testGoal1Text));
    goalsManager.edit(testGoal2, 0);
    expect(goalsManager.goalList!.first.text, equals(testGoal2Text));
  });

  group('Reorders a goal', () {
    setUp(() {
      for (int i = 0; i < 5; i++) {
        PracticeGoal goal = PracticeGoal(text: '$i');
        goalsManager.add(goal);
      }
    });

    test('towards back', () {
      // [0, 1, 2, 3, 4]
      // => [1, 2, 3, 4, 0]
      goalsManager.move(0, 4);
      expect(goalsManager.goalList![0].text, equals('1'));
      expect(goalsManager.goalList![4].text, equals('0'));
    });

    test('towards front', () {
      // [0, 1, 2, 3, 4]
      // => [0, 4, 1, 2, 3]
      goalsManager.move(4, 1);
      expect(goalsManager.goalList![1].text, equals('4'));
      expect(goalsManager.goalList![4].text, equals('3'));
    });
  });

  group('Toggles tick status', () {
    test('to ticked', () {
      goalsManager.add(testGoal1);
      goalsManager.toggleIsTicked(0);
      expect(goalsManager.goalList!.first.isTicked, equals(true));
    });
    test('to unticked', () {
      PracticeGoal tickedGoal =
          PracticeGoal(text: testGoal1Text, isTicked: true);
      goalsManager.add(tickedGoal);
      goalsManager.toggleIsTicked(0);
      expect(goalsManager.goalList!.first.isTicked, equals(false));
    });
  });

  test('Deletes all', () {
    for (int i = 0; i < 5; i++) {
      goalsManager.add(testGoal1);
    }
    expect(goalsManager.goalList!.length, equals(5));
    goalsManager.deleteAll();
    expect(goalsManager.goalList!.length, equals(0));
  });

  group('Saves goal data', () {
    final PracticeGoal goal1 = PracticeGoal(text: 'Goal1');
    final PracticeGoal goal2 = PracticeGoal(text: 'Goal2', isTicked: true);

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });
    test('correctly for 1 goal', () async {
      goalsManager.add(goal1);
      await goalsManager.saveData();

      PracticeGoalManager result = PracticeGoalManager();
      await result.fetchData();
      expect(result.goalList!.length, equals(1));
      expect(result.goalList!.first.text, equals('Goal1'));
      expect(result.goalList!.first.isTicked, equals(false));
    });

    test('correctly for multiple goals', () async {
      goalsManager.add(goal1);
      goalsManager.add(goal2);
      await goalsManager.saveData();

      PracticeGoalManager result = PracticeGoalManager();
      await result.fetchData();
      expect(result.goalList!.length, equals(2));
      expect(result.goalList!.last.text, equals('Goal2'));
      expect(result.goalList!.last.isTicked, equals(true));
    });

    test('correctly for empty goal list', () async {
      await goalsManager.saveData();
      expect(goalsManager.goalList!.length, equals(0));
    });
  });
}
