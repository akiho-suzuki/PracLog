import 'package:flutter/material.dart';
import 'package:praclog/main.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/mid_practice_data.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/models/timer_data.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/log_database.dart';
import 'package:praclog/services/database/piece_stats.database.dart';
import 'package:praclog/services/database/week_data_database.dart';
import 'package:praclog/ui/logs/log_info_screen.dart';
import 'package:praclog/ui/practice/widgets/duration_edit_popup.dart';
import 'package:praclog/ui/practice/widgets/goal_listview.dart';
import 'package:praclog/ui/practice/widgets/rating_scale.dart';
import 'package:praclog/ui/widgets/custom_scaffold.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:praclog/ui/widgets/piece_info_tile.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import '../../helpers/null_empty_helper.dart';

const double _spacingHeight = 7.0;

class PostPracticeScreen extends StatefulWidget {
  //final Piece piece;
  final String pieceTitle;
  final String pieceComposer;
  final String pieceId;

  /// In minutes
  final int duration;
  final int? movement;
  final String? movementTitle;
  final bool isEdit;
  final Log? oldLog;

  const PostPracticeScreen({
    Key? key,
    //required this.piece,
    required this.pieceId,
    required this.pieceTitle,
    required this.pieceComposer,
    required this.duration,
    required this.movement,
    this.movementTitle,
    this.isEdit = false,
    this.oldLog,
  })  
  // If isEdit oldLog cannot be null
  : assert(isEdit ? oldLog != null : true),
        // If there is a movement, the title must also be specified
        assert(movement != null ? movementTitle != null : true),
        super(key: key);

  @override
  State<PostPracticeScreen> createState() => _PostPracticeScreenState();
}

class _PostPracticeScreenState extends State<PostPracticeScreen> {
  late int _duration;
  int? _satisfaction;
  int? _progress;
  int? _focus;
  late final TextEditingController _notesController;

  /// If it's a new log, `practiceGoalManager` is set to the one from `context.watch<PracticeGoalManager>()`.
  ///
  /// If it's an edit and the old log has goals, a new `PracticeGoalManager` will be created in `initState` and `goalList` will be set to the old goals.
  ///
  /// If it's an edit and the old goals has no goals, `practiceGoalManager` will be `null`.
  PracticeGoalManager? practiceGoalManager;

  @override
  void initState() {
    // For edits (set original values)
    if (widget.isEdit) {
      _satisfaction = widget.oldLog!.satisfaction;
      _progress = widget.oldLog!.progress;
      _focus = widget.oldLog!.focus;
      _duration = widget.oldLog!.durationInMin;
      _notesController = TextEditingController(text: widget.oldLog!.notes);
    } else {
      // For new logs (post practice)
      _notesController = TextEditingController();
      _duration = widget.duration;
    }
    super.initState();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    AuthManager authManager = context.read<AuthManager>();
    List<PracticeGoal>? goalList;
    if (widget.isEdit) {
      if (practiceGoalManager != null) {
        goalList = practiceGoalManager!.clonedGoalList;
      }
    } else {
      goalList = practiceGoalManager!.goalList;
    }

    // Create the log to be saved
    Log log = Log(
        pieceId: widget.pieceId,
        title: widget.pieceTitle,
        composer: widget.pieceComposer,
        movementIndex: widget.movement,
        movementTitle: widget.movementTitle,
        durationInMin: _duration,
        date: widget.isEdit ? widget.oldLog!.date : DateTime.now(),
        goalsList: goalList,
        satisfaction: _satisfaction,
        focus: _focus,
        progress: _progress,
        notes: _notesController.text,
        id: widget.isEdit ? widget.oldLog!.id : null);

    LogDatabase logDatabase =
        LogDatabase(logCollection: authManager.userLogCollection);
    PieceStatsDatabase pieceStatsDatabase = PieceStatsDatabase(
        authManager.userPieceStatsCollection(widget.pieceId));
    WeekDataDatabase weekDataDatabase = WeekDataDatabase(
        weekDataCollection: authManager.userWeekDataCollection);

    // Edit log
    if (widget.isEdit) {
      Log.editLog(
        newLog: log,
        oldLog: widget.oldLog!,
        logDatabase: logDatabase,
        weekDataDatabase: weekDataDatabase,
        pieceStatsDatabase: pieceStatsDatabase,
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogInfoScreen(log: log)),
          (route) => route.isFirst);
      // Or add log
    } else {
      Log.addLog(
        log: log,
        logDatabase: logDatabase,
        weekDataDatabase: weekDataDatabase,
        pieceStatsDatabase: pieceStatsDatabase,
      );

      // Set midPractice to false
      MidPracticeData.setMidPracticeToFalse();

      // Clear timer data
      context.read<TimerData>().clear();

      // Goes back to home screen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const AuthWrapper(
                    initialIndex: 2,
                  )),
          ((route) => false));
    }
    // Clear practice goals
    practiceGoalManager?.deleteAll();
  }

  Widget _buildGoalList() {
    if (practiceGoalManager != null &&
        practiceGoalManager!.goalList.isNotNullOrEmpty) {
      return RoundedWhiteCard(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ExpansionTile(
          leading: const Icon(Icons.check_box),
          title: const Text('My Goals'),
          children: [
            GoalListView(practiceGoalManager: practiceGoalManager!),
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
      if (widget.oldLog!.goalsList.isNotNullOrEmpty) {
        practiceGoalManager = context.watch<PracticeGoalManager>();
        practiceGoalManager!.setGoalList = widget.oldLog!.goalsList!;
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
              title: widget.pieceTitle,
              composer: widget.pieceComposer,
              movementIndex: widget.movement,
              movementTitle: widget.movementTitle),
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
          _buildGoalList(),
          const SizedBox(height: _spacingHeight),
          // Satisfaction rating scale
          RatingScale(
            initialValue: widget.isEdit ? widget.oldLog!.satisfaction : null,
            icon: const Icon(Icons.sentiment_satisfied_alt),
            title: 'Satisfaction',
            onChanged: (int value) {
              _satisfaction = value;
            },
          ),
          const SizedBox(height: _spacingHeight),
          // Focus rating scale
          RatingScale(
            initialValue: widget.isEdit ? widget.oldLog!.focus : null,
            icon: const Icon(Icons.psychology),
            title: 'Focus',
            onChanged: (int value) {
              _focus = value;
            },
          ),
          const SizedBox(height: _spacingHeight),
          // Progress rating scale
          RatingScale(
            initialValue: widget.isEdit ? widget.oldLog!.progress : null,
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
