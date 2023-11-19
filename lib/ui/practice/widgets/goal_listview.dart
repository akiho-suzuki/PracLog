import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/data_managers/practice_goal_manager.dart';
import 'package:praclog_v2/ui/widgets/custom_reorderable_listview.dart';
import 'package:praclog_v2/ui/widgets/goal_card.dart';

class GoalListView extends StatelessWidget {
  final PracticeGoalManager _practiceGoalManager;
  final bool tickEnabled;

  /// Pass when using in `PracticeScreen` to save any updates to the goal list immediately to Isar db.
  ///
  /// This is to make sure that the practice session can be restored if the app gets killed during a practice session.
  ///
  /// A temporary workaround for Isar bug which means that I can't monitor the state of the app
  /// using lifecycle
  ///
  /// TODO remove when Isar Issue #1068 gets resolved
  final AsyncCallback? saveDataToIsarFunc;

  const GoalListView({
    Key? key,
    required PracticeGoalManager practiceGoalManager,
    this.tickEnabled = true,
    this.saveDataToIsarFunc,
  })  : _practiceGoalManager = practiceGoalManager,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomReorderableListView.separated(
      physics: const ClampingScrollPhysics(),
      separatorBuilder: (_, __) => const Divider(
        height: 16,
        color: kLightTextColor,
      ),
      shrinkWrap: true,
      itemCount: _practiceGoalManager.goalListLength,
      onReorder: (int oldIndex, int newIndex) {
        _practiceGoalManager.move(oldIndex, newIndex);
        saveDataToIsarFunc?.call();
      },
      itemBuilder: (context, index) => GoalCard(
        key: Key('$index'),
        goalCardType: GoalCardType.currentInPractice,
        text: _practiceGoalManager.goalList[index].text,
        tickState: _practiceGoalManager.goalList[index].isTicked,
        edit: (String value) {
          _practiceGoalManager.edit(
              PracticeGoal()
                ..text = value
                ..isTicked = _practiceGoalManager.goalList[index].isTicked,
              index);
          saveDataToIsarFunc?.call();
        },
        delete: () {
          _practiceGoalManager.delete(index);
          saveDataToIsarFunc?.call();
        },
        toggleTick: tickEnabled
            ? () {
                _practiceGoalManager.toggleIsTicked(index);
                saveDataToIsarFunc?.call();
              }
            : null,
      ),
    );
  }
}
