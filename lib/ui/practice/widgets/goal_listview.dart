import 'package:flutter/material.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/custom_reorderable_listview.dart';
import 'package:praclog/ui/widgets/goal_card.dart';

class GoalListView extends StatelessWidget {
  final PracticeGoalManager _practiceGoalManager;
  final bool tickEnabled;

  const GoalListView({
    Key? key,
    required PracticeGoalManager practiceGoalManager,
    this.tickEnabled = true,
  })  : _practiceGoalManager = practiceGoalManager,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomReorderableListView.separated(
      physics: const ClampingScrollPhysics(),
      separatorBuilder: (_, __) => const Divider(
        height: 16,
        color: CustomColors.lightTextColor,
      ),
      shrinkWrap: true,
      itemCount: _practiceGoalManager.goalListLength,
      onReorder: (int oldIndex, int newIndex) {
        _practiceGoalManager.move(oldIndex, newIndex);
      },
      itemBuilder: (context, index) => GoalCard(
          key: Key('$index'),
          goalCardType: GoalCardType.currentInPractice,
          text: _practiceGoalManager.goalList![index].text,
          tickState: _practiceGoalManager.goalList![index].isTicked,
          edit: (String value) {
            _practiceGoalManager.edit(
                PracticeGoal(
                    text: value,
                    isTicked: _practiceGoalManager.goalList![index].isTicked),
                index);
          },
          delete: () {
            _practiceGoalManager.delete(index);
          },
          toggleTick: tickEnabled
              ? () {
                  _practiceGoalManager.toggleIsTicked(index);
                }
              : null),
    );
  }
}
