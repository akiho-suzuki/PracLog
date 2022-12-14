import 'package:flutter/material.dart';
import 'package:praclog/models/timer_data.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
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
        TimerData timerData = context.read<TimerData>();
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
    TimerData timerData = context.watch<TimerData>();
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
          color: timerData.timerOn()
              ? CustomColors.lightTextColor
              : CustomColors.primaryColor,
          iconSize: 80.0,
          icon: timerData.timerOn()
              ? const Icon(Icons.pause_circle)
              : const Icon(Icons.play_circle_fill),
          onPressed: () async {
            // Start or stop timer
            if (timerData.timerOn()) {
              timerData.stopTimer(DateTime.now());
              _stopwatch.onStopTimer();
            } else {
              timerData.startTimer(DateTime.now());
              _stopwatch.onStartTimer();
            }
          },
        ),
      ],
    );
  }
}
