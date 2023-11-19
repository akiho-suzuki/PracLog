import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/data_managers/practice_goal_manager.dart';
import 'package:praclog_v2/data_managers/timer_data_manager.dart';
import 'package:praclog_v2/main.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/ui/practice/post_practice_screen.dart';
import 'package:praclog_v2/ui/practice/widgets/practice_goal_form.dart';
import 'package:praclog_v2/ui/practice/widgets/timer.dart';
import 'package:praclog_v2/ui/widgets/main_button.dart';
import 'package:praclog_v2/utils/show_popup.dart';
import 'package:provider/provider.dart';

class PracticeScreen extends StatefulWidget {
  final Log log;
  final Isar isar;
  final Piece piece;
  final int? movement;
  final bool restored;

  const PracticeScreen(
      {Key? key,
      required this.isar,
      required this.piece,
      required this.log,
      this.movement,
      this.restored = false})
      : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

// TODO once Isar issue #1068 gets resolved, consider going back to `WidgetsBindingObserver` and using `didChangeAppLifecycleState` to save data to Isar db when app goes to sleep
class _PracticeScreenState extends State<PracticeScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    if (widget.restored) {
      restorePractice();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // If this is continuing a previous practice session, get all the data
  // (i.e. goals and timerData)
  Future restorePractice() async {
    // Set the timer data
    TimerDataManager timerDataManager = context.read<TimerDataManager>();
    timerDataManager.setTimerDataList = widget.log.timerDataList;
    // Set the goal data
    PracticeGoalManager goalManager = context.read<PracticeGoalManager>();
    goalManager.setGoalList =
        widget.log.goalsList == null ? [] : widget.log.goalsList!;
  }

  // Updates the goal list and timer data with the most recent data
  Future savePracticeData({bool isFinished = false}) async {
    TimerDataManager timerDataManager = context.read<TimerDataManager>();
    PracticeGoalManager goalManager = context.read<PracticeGoalManager>();
    await LogDatabase(isar: widget.isar).midPracticeSave(widget.log,
        goalManager.goalList, timerDataManager.timerDataList, isFinished);
  }

  void _onSubmit() async {
    savePracticeData(isFinished: true);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostPracticeScreen(
                isar: widget.isar,
                log: widget.log,
                piece: widget.piece,
                duration: context.read<TimerDataManager>().timerMinValue())));
    // If user comes back to this page through the back button, reset the `inProgress` to `true`
    savePracticeData();
  }

  Timer _buildTimer() {
    if (widget.restored) {
      return Timer(restored: true, onPressSaveData: savePracticeData);
    } else {
      return Timer(restored: false, onPressSaveData: savePracticeData);
    }
  }

  void _cancelPractice() async {
    bool? response = await showConfirmPopup(context,
        message: "Are you sure want to quit this practice session?",
        confirmButtonText: 'Quit',
        title: "Quit practice?");

    if (response == true && mounted) {
      // Clear practice goals
      context.read<PracticeGoalManager>().deleteAll();
      // Clear timer data
      context.read<TimerDataManager>().clearTimer();
      // Delete the log data
      await LogDatabase(isar: widget.isar).deleteLog(widget.log);

      if (mounted) {
        // Goes back to home screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreenWrapper(isar: widget.isar)),
            (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TimerDataManager timerDataManager = context.watch<TimerDataManager>();
    return Scaffold(
      // To allow the keyboard to cover the timer/button area
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _cancelPractice();
              },
              icon: const Icon(Icons.cancel_outlined),
              color: kLightTextColor),
        ],
        backgroundColor: kBackgroundColor,
        elevation: 0.0,
        foregroundColor: kMainTextColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('${widget.piece.composer}: ${widget.piece.title}'),
        bottom: (widget.movement == null)
            ? null
            : PreferredSize(
                preferredSize: Size.zero,
                child: Text(widget.piece.movements![widget.movement!]),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PracticeGoalForm(
                onTextFieldChange: (_) {},
                controller: _controller,
                initialShowTextField: false,
                goalTickEnabled: true,
                showAsListView: true,
                saveDataToIsarFunc: savePracticeData,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTimer(),
                MainButton(
                    text: 'Finish',
                    onPressed: timerDataManager.timerOn() ? null : _onSubmit),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
