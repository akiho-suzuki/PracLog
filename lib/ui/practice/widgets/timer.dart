import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/data_managers/timer_data_manager.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

const TextStyle _timerDisplay = TextStyle(
  fontSize: 70.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'Helvetica',
);

class Timer extends StatefulWidget {
  final bool restored;
  const Timer({
    Key? key,
    this.restored = false,
  }) : super(key: key);

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final StopWatchTimer _stopwatch = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    if (widget.restored) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TimerDataManager timerData = context.read<TimerDataManager>();
        _stopwatch.setPresetTime(mSec: timerData.currentTimerValue() * 1000);
        if (timerData.timerOn()) {
          _stopwatch.onStartTimer();
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopwatch.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TimerDataManager timerDataManager = context.watch<TimerDataManager>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<int>(
            stream: _stopwatch.rawTime,
            initialData: _stopwatch.rawTime.value,
            builder: (context, snap) {
              final value = snap.data;
              final displayTime =
                  StopWatchTimer.getDisplayTime(value!, milliSecond: false);
              return Text(displayTime, style: _timerDisplay);
            }),
        IconButton(
          color: TimerDataManager().timerOn() ? kLightTextColor : kPrimaryColor,
          iconSize: 80.0,
          icon: timerDataManager.timerOn()
              ? const Icon(Icons.pause_circle)
              : const Icon(Icons.play_circle_fill),
          onPressed: () async {
            // Start or stop timer
            if (timerDataManager.timerOn()) {
              timerDataManager.stopTimer(DateTime.now());
              _stopwatch.onStopTimer();
            } else {
              timerDataManager.startTimer(DateTime.now());
              _stopwatch.onStartTimer();
            }
          },
        ),
      ],
    );
  }
}
