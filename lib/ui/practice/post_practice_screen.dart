import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/data_managers/practice_goal_manager.dart';
import 'package:praclog_v2/data_managers/timer_data_manager.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/ui/practice/widgets/duration_edit_popup.dart';
import 'package:praclog_v2/ui/practice/widgets/goal_listview.dart';
import 'package:praclog_v2/ui/practice/widgets/rating_scale.dart';
import 'package:praclog_v2/ui/widgets/custom_scaffold.dart';
import 'package:praclog_v2/ui/widgets/main_button.dart';
import 'package:praclog_v2/ui/widgets/piece_info_tile.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import '../../helpers/null_empty_helpers.dart';

const double _spacingHeight = 7.0;

class PostPracticeScreen extends StatefulWidget {
  final Isar isar;
  final Log log;
  final Piece piece;

  final int duration; // in minutes
  final bool isEdit;

  const PostPracticeScreen({
    Key? key,
    required this.isar,
    required this.piece,
    required this.duration,
    this.isEdit = false,
    required this.log,
  }) : super(key: key);

  @override
  State<PostPracticeScreen> createState() => _PostPracticeScreenState();
}

class _PostPracticeScreenState extends State<PostPracticeScreen> {
  late int _duration;
  int? _satisfaction;
  int? _progress;
  int? _focus;
  late final TextEditingController _notesController;
  PracticeGoalManager? practiceGoalManager;

  /// This is to see if the goals have been fetched from the database
  /// and copied into the `PracticeGoalManager` object (`setGoalList`) when
  /// in editing mode, to make sure that it is not set again.
  ///
  /// This is necessary because Isar returns a fixed length list, meaning
  /// that you cannot change delete a goal or clear the list at the end.
  bool goalsSet = true;

  @override
  void initState() {
    // For edits (set original values)
    if (widget.isEdit) {
      goalsSet = false;
      _satisfaction = widget.log.satisfaction;
      _progress = widget.log.progress;
      _focus = widget.log.focus;
      _duration = widget.log.durationInMin ?? 0; //TODO check
      _notesController = TextEditingController(text: widget.log.notes);
    } else {
      // For new logs (post practice)
      _notesController = TextEditingController();
      _duration = widget.duration;
    }
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (widget.log.goalsList.isNotNullOrEmpty) {
  //     practiceGoalManager = context.watch<PracticeGoalManager>();
  //     practiceGoalManager!.setGoalList = widget.log.goalsList!;
  //   } else {
  //     practiceGoalManager = context.watch<PracticeGoalManager>();
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    TimerDataManager timerDataManager = context.read<TimerDataManager>();

    widget.log
      ..durationInMin = widget.isEdit ? _duration : widget.duration
      ..focus = _focus
      ..satisfaction = _satisfaction
      ..progress = _progress
      ..notes = _notesController.text
      ..completed = true
      ..goalsList = practiceGoalManager?.goalList;

    await LogDatabase(isar: widget.isar).saveLog(widget.log);

    // Clear timer data
    timerDataManager.clearTimer();
    // Clear practice goals
    practiceGoalManager?.deleteAll();

    // Goes back to home screen
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  Widget _buildGoalList(PracticeGoalManager? practiceGoalManager) {
    if (practiceGoalManager != null &&
        practiceGoalManager.goalList.isNotNullOrEmpty) {
      return RoundedWhiteCard(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ExpansionTile(
          leading: const Icon(Icons.check_box),
          title: const Text('My Goals'),
          children: [
            GoalListView(practiceGoalManager: practiceGoalManager),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<int?> _editDuration(BuildContext context) {
    return showDialog<int?>(
      context: context,
      builder: (context) => DurationEditPopup(initialDuration: _duration),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      if (widget.log.goalsList.isNotNullOrEmpty) {
        practiceGoalManager = context.watch<PracticeGoalManager>();
        if (goalsSet == false) {
          practiceGoalManager!.setGoalList = widget.log.goalsList!;
          goalsSet = true;
        }
      }
    } else {
      practiceGoalManager = context.watch<PracticeGoalManager>();
    }

    return CustomScaffold(
      appBarTitle: widget.isEdit ? 'Edit log' : 'Finish practice',
      body: ListView(
        children: [
          // Piece info
          PieceInfoTile(
            piece: widget.piece,
            movementIndex: widget.log.movementIndex,
          ),
          const SizedBox(height: _spacingHeight),
          // Duration
          DurationListTile(
            duration: _duration,
            onPressEdit: widget.isEdit
                ? () async {
                    var result = await _editDuration(context);
                    setState(() {
                      _duration = result ?? widget.duration;
                    });
                  }
                : null,
          ),
          const SizedBox(height: _spacingHeight),
          // Goal list
          _buildGoalList(practiceGoalManager),
          const SizedBox(height: _spacingHeight),
          // Satisfaction rating scale
          RatingScale(
            initialValue: widget.isEdit ? widget.log.satisfaction : null,
            icon: const Icon(Icons.sentiment_satisfied_alt),
            title: 'Satisfaction',
            onChanged: (int value) {
              _satisfaction = value;
            },
          ),
          const SizedBox(height: _spacingHeight),
          // Focus rating scale
          RatingScale(
            initialValue: widget.isEdit ? widget.log.focus : null,
            icon: const Icon(Icons.psychology),
            title: 'Focus',
            onChanged: (int value) {
              _focus = value;
            },
          ),
          const SizedBox(height: _spacingHeight),
          // Progress rating scale
          RatingScale(
            initialValue: widget.isEdit ? widget.log.progress : null,
            icon: const Icon(Icons.trending_up),
            title: 'Progress',
            onChanged: (int value) {
              _progress = value;
            },
          ),
          const SizedBox(height: _spacingHeight),
          // Notes textfield
          RoundedWhiteCard(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Enter notes',
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(height: _spacingHeight),
          // Submit button
          MainButton(
            text: 'Finish',
            onPressed: () {
              _onSubmit();
            },
          ),
        ],
      ),
    );
  }
}
