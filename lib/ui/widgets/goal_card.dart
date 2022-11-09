import 'package:flutter/material.dart';

/// `newInPractice` = shows a textField to add a new goal. No edit/delete, cannot be ticked.
///
/// `currentInPractice` = to show goals during practice
///
/// `showInLog` = to show on a log. No edit/delete, cannot be ticked
enum GoalCardType { newInPractice, currentInPractice, showInLog }

/// Practice goal action options. `edit` or `delete`.
enum PracGoalOptions { edit, delete }

class GoalCard extends StatefulWidget {
  final String? text;
  final bool tickState;
  final VoidCallback? delete;
  final void Function(String value)? edit;
  final VoidCallback? toggleTick;
  final TextEditingController? controller;
  final GoalCardType goalCardType;
  final void Function(String? value)? onTextfieldChange;
  // Returns true if a goal is successfully created, false is not.
  final bool Function(String? value)? createGoal;

  const GoalCard({
    Key? key,
    required this.goalCardType,
    required this.tickState,
    this.text,
    this.delete,
    this.edit,
    this.toggleTick,
    this.controller,
    this.createGoal,
    this.onTextfieldChange,

    // If it's for currentInPractice, text, delete, and edit must not be null
  })  : assert(goalCardType == GoalCardType.currentInPractice
            ? text != null
            : true),
        assert(goalCardType == GoalCardType.currentInPractice
            ? delete != null
            : true),
        assert(goalCardType == GoalCardType.currentInPractice
            ? edit != null
            : true),

        // If it's for a new goal, createGoal, controller, onTextFieldChange must not be null
        assert(goalCardType == GoalCardType.newInPractice
            ? createGoal != null
            : true),
        assert(goalCardType == GoalCardType.newInPractice
            ? controller != null
            : true),
        assert(goalCardType == GoalCardType.newInPractice
            ? onTextfieldChange != null
            : true),

        // If it's for a goal to show in log, text must not be null
        assert(goalCardType == GoalCardType.showInLog ? text != null : true),
        super(key: key);

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool _isEdit = false;

  Widget get _textField => TextFormField(
        controller: widget.controller,
        autofocus: _isEdit ? true : false,
        initialValue: _isEdit ? widget.text : null,
        decoration: const InputDecoration(
          hintText: 'Add a goal',
        ),
        onChanged: (String? value) {
          if (_isEdit == false) {
            widget.onTextfieldChange!(value);
          }
        },
        onFieldSubmitted: (String? value) {
          if (_isEdit) {
            if (value != null && value.isNotEmpty) {
              widget.edit!(value);
            }
            setState(() {
              _isEdit = false;
            });
          } else {
            bool result = widget.createGoal!(value);
            if (result == true) {
              widget.controller!.clear();
            }
          }
        },
      );

  PopupMenuButton<PracGoalOptions> get popUpOptions =>
      PopupMenuButton<PracGoalOptions>(
        onSelected: (PracGoalOptions selectedOption) {
          if (selectedOption == PracGoalOptions.delete) {
            widget.delete!();
          } else {
            setState(() {
              _isEdit = true;
            });
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<PracGoalOptions>>[
          const PopupMenuItem(value: PracGoalOptions.edit, child: Text('Edit')),
          const PopupMenuItem(
              value: PracGoalOptions.delete, child: Text('Delete')),
        ],
      );

  Widget? get _trailing {
    if (widget.goalCardType == GoalCardType.newInPractice) {
      return IconButton(
          onPressed: () {
            widget.controller!.clear();
          },
          icon: const Icon(Icons.backspace_outlined));
    } else if (widget.goalCardType == GoalCardType.currentInPractice) {
      return popUpOptions;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.tickState,
        onChanged: (v) {
          if (widget.toggleTick != null) {
            widget.toggleTick!();
          }
        },
      ),
      title: (widget.goalCardType == GoalCardType.newInPractice || _isEdit)
          ? _textField
          : Text(widget.text!),
      trailing: _trailing,
    );
  }
}
