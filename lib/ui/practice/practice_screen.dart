import 'package:flutter/material.dart';
import 'package:praclog/main.dart';
import 'package:praclog/models/mid_practice_data.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/models/timer_data.dart';
import 'package:praclog/ui/practice/post_practice_screen.dart';
import 'package:praclog/ui/practice/widgets/practice_goal_form.dart';
import 'package:praclog/ui/practice/widgets/timer.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/utils/show_dialog.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:provider/provider.dart';

class PracticeScreen extends StatefulWidget {
  final String pieceTitle;
  final String pieceId;
  final String pieceComposer;
  final int? movement;
  final String? movementTitle;
  final bool restored;

  const PracticeScreen(
      {Key? key,
      required this.pieceTitle,
      required this.pieceComposer,
      required this.pieceId,
      this.movementTitle,
      this.movement,
      this.restored = false})
      : // If there is a movement, the title must also be specified
        assert(movement != null ? movementTitle != null : true),
        super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

// The `WidgetBindingObserver` is to get notified when the user leaves the app
// so that `PracticeGoal` and `TimerData` can be stored locally
class _PracticeScreenState extends State<PracticeScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = TextEditingController();
    MidPracticeData(
            pieceId: widget.pieceId,
            pieceComposer: widget.pieceComposer,
            pieceTitle: widget.pieceTitle,
            movementIndex: widget.movement,
            movementTitle: widget.movementTitle)
        .startPractice();
    super.initState();
  }

  // When user exits from the app (switches to another screen), save goal and timerdata
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      TimerData timerData = context.read<TimerData>();
      timerData.saveData();
      PracticeGoalManager goals = context.read<PracticeGoalManager>();
      goals.saveData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() {
    TimerData timerData = context.read<TimerData>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPracticeScreen(
            pieceId: widget.pieceId,
            pieceTitle: widget.pieceTitle,
            pieceComposer: widget.pieceComposer,
            movement: widget.movement,
            movementTitle: widget.movementTitle,
            duration: timerData.timerMinValue()),
      ),
    );
  }

  void _cancelPractice() async {
    bool? response = await showConfirmPopup(context,
        message: "Are you sure want to quit this practice session?",
        confirmButtonText: 'Quit',
        title: "Quit practice?");

    if (response == true && mounted) {
      // Clear practice goals
      context.read<PracticeGoalManager>().deleteAll();

      // Set midPractice to false
      MidPracticeData.setMidPracticeToFalse();

      // Clear timer data
      context.read<TimerData>().clear();

      // Goes back to home screen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          ((route) => false));
    }
  }

  @override
  Widget build(BuildContext context) {
    TimerData timerData = context.watch<TimerData>();
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
            color: CustomColors.lightTextColor,
          ),
        ],
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0.0,
        foregroundColor: CustomColors.mainTextColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('${widget.pieceComposer}: ${widget.pieceTitle}'),
        bottom: (widget.movement == null)
            ? null
            : PreferredSize(
                preferredSize: Size.zero,
                child: Text(widget.movementTitle!),
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
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Timer(
                  restored: widget.restored,
                ),
                MainButton(
                    text: 'Finish',
                    onPressed: timerData.timerOn() ? null : _onSubmit),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
