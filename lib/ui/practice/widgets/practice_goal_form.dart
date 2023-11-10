import 'package:flutter/material.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/practice_goal_manager.dart';
import 'package:praclog_v2/ui/practice/widgets/goal_listview.dart';
import 'package:praclog_v2/ui/widgets/goal_card.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';

/// Shows practice goal list with a heading and textfield (which can be toggled on and off)
class PracticeGoalForm extends StatefulWidget {
  /// Called each time there is a change in the textfield. Use to keep track of current goal in the text field.
  final void Function(String? value) onTextFieldChange;

  /// Text editing controller for the textField allowing user to add new goals.
  final TextEditingController controller;

  /// If `true`, shows the textfield at start. Use for `PrePracticeScreen`.
  final bool initialShowTextField;

  /// If `true`, allows user to tick off goals.
  final bool goalTickEnabled;

  /// Called when a goal is added
  final VoidCallback? onGoalAdd;

  /// If set to `true`, the children are shown in as a `ListView` with `shrinkwrap = true`. Otherwise, the children are shown in a `Column`. Defaults to `false`.
  ///
  /// Set to `true` for `PracticeScreen` to allow for scrolling, while keeping the timer widget at the bottom of the screen.
  final bool showAsListView;

  const PracticeGoalForm({
    required this.onTextFieldChange,
    required this.controller,
    required this.initialShowTextField,
    required this.goalTickEnabled,
    this.onGoalAdd,
    this.showAsListView = false,
    Key? key,
  }) : super(key: key);

  @override
  State<PracticeGoalForm> createState() => _PracticeGoalFormState();
}

class _PracticeGoalFormState extends State<PracticeGoalForm> {
  late bool _showTextField;

  @override
  void initState() {
    _showTextField = widget.initialShowTextField;
    super.initState();
  }

  Widget _buildTextField(PracticeGoalManager practiceGoalManager) => Row(
        children: [
          Expanded(
            child: GoalCard(
              text: null,
              tickState: false,
              goalCardType: GoalCardType.newInPractice,
              controller: widget.controller,
              onTextfieldChange: (String? value) {
                widget.onTextFieldChange(value);
              },
              createGoal: (String? value) {
                if (value != null && value.isNotEmpty) {
                  PracticeGoal goal = PracticeGoal()
                    ..text = value
                    ..isTicked = false;
                  practiceGoalManager.add(goal);
                  if (widget.onGoalAdd != null) {
                    widget.onGoalAdd!();
                  }
                  return true;
                } else {
                  return false;
                }
              },
            ),
          ),
        ],
      );

  List<Widget> _getListChildren(PracticeGoalManager practiceGoalManager) {
    return [
      RoundedWhiteCard(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text('Goals for session:', style: kSubheading),
            ),
            const SizedBox(height: 5.0),
            // Listview of goals
            GoalListView(
              practiceGoalManager: practiceGoalManager,
              tickEnabled: widget.goalTickEnabled,
            ),
            // Textfield (or blank space)
            _showTextField
                ? _buildTextField(practiceGoalManager)
                : const SizedBox.shrink(),
          ],
        ),
      ),
      widget.initialShowTextField
          ? const SizedBox.shrink()
          : TextButton(
              style: const ButtonStyle(alignment: Alignment.centerRight),
              onPressed: () {
                setState(() {
                  _showTextField = _showTextField ? false : true;
                });
              },
              child: Text(
                _showTextField ? 'Hide textfield' : 'Add new goal',
                style: const TextStyle(color: kLightTextColor),
              ),
            ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var practiceGoalManager = context.watch<PracticeGoalManager>();

    return widget.showAsListView
        ? ListView(
            shrinkWrap: true,
            children: _getListChildren(practiceGoalManager),
          )
        : Column(
            children: _getListChildren(practiceGoalManager),
          );
  }
}
