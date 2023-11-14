import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/data_managers/logs_delete_manager.dart';
import 'package:praclog_v2/helpers/log_helper.dart';
import 'package:praclog_v2/ui/logs/log_info_screen.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';

// The LogCard widget
class LogCard extends StatefulWidget {
  final Isar isar;
  final Log log;

  const LogCard({
    Key? key,
    required this.isar,
    required this.log,
  }) : super(key: key);

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  int _getNumTickedGoals(List<PracticeGoal> goalList) {
    int i = 0;
    for (PracticeGoal goal in goalList) {
      goal.isTicked ? i++ : null;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    LogsDeleteManager logsDeleteManager = context.watch<LogsDeleteManager>();
    int nGoals =
        (widget.log.goalsList != null && widget.log.goalsList!.isNotEmpty)
            ? widget.log.goalsList!.length
            : 0;
    int nTickedGoals =
        nGoals != 0 ? _getNumTickedGoals(widget.log.goalsList!) : 0;

    return GestureDetector(
      onTap: () async {
        if (logsDeleteManager.on) {
          setState(() {
            logsDeleteManager.logIds.contains(widget.log.id)
                ? logsDeleteManager.remove(widget.log.id)
                : logsDeleteManager.add(widget.log.id);
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogInfoScreen(
                isar: widget.isar,
                log: widget.log,
              ),
            ),
          );
        }
      },
      onLongPress: () {
        if (logsDeleteManager.on == false) {
          logsDeleteManager.add(widget.log.id);
          setState(() {
            logsDeleteManager.on = true;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RoundedWhiteCard(
          padding: const EdgeInsets.all(0.0),
          color: logsDeleteManager.logIds.contains(widget.log.id)
              ? kPrimaryColorLight
              : null,
          child: ListTile(
            // Date
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateFormat.MMM().format(widget.log.dateTime),
                  style: kDateTextStyle,
                ),
                Text(
                  widget.log.dateTime.day.toString(),
                  style: kDateTextStyle,
                ),
              ],
            ),
            // Piece name
            title: Padding(
              padding: const EdgeInsets.only(
                bottom: 5.0,
              ),
              child: Text(LogHelper.getPieceName(widget.log)),
            ),
            // Ratings
            subtitle: IntrinsicHeight(
              child: Row(
                children: [
                  Text('${widget.log.durationInMin} min'),
                  kVerticalSeparator,
                  Text('$nTickedGoals/$nGoals goals'),
                  RatingBox(
                    rating: widget.log.satisfaction,
                    iconData: kSatisfactionIcon,
                  ),
                  RatingBox(
                    rating: widget.log.focus,
                    iconData: kFocusIcon,
                  ),
                  RatingBox(
                    rating: widget.log.progress,
                    iconData: kProgressIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RatingBox extends StatelessWidget {
  final int? rating;
  final IconData iconData;
  const RatingBox({Key? key, required this.rating, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        kVerticalSeparator,
        Icon(iconData, size: 16.0),
        kVerticalSpace,
        Text(rating != null ? rating.toString() : '-'),
      ],
    );
  }
}
