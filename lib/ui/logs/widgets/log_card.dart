import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/log_helper.dart';
import 'package:praclog_v2/ui/logs/log_info_screen.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

// The LogCard widget
class LogCard extends StatelessWidget {
  final Isar isar;
  final Log log;
  final bool isSelected;
  final bool multipleDeleteMode;
  final VoidCallback onLongPress;
  final VoidCallback onTapInMultipleDelete;

  const LogCard({
    Key? key,
    required this.isar,
    required this.log,
    required this.onLongPress,
    required this.multipleDeleteMode,
    required this.onTapInMultipleDelete,
    this.isSelected = false,
  }) : super(key: key);

  int _getNumTickedGoals(List<PracticeGoal> goalList) {
    int i = 0;
    for (PracticeGoal goal in goalList) {
      goal.isTicked ? i++ : null;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    int nGoals = (log.goalsList != null && log.goalsList!.isNotEmpty)
        ? log.goalsList!.length
        : 0;
    int nTickedGoals = nGoals != 0 ? _getNumTickedGoals(log.goalsList!) : 0;

    return GestureDetector(
      onTap: () async {
        if (multipleDeleteMode) {
          // onTapInMultipleDelete();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogInfoScreen(
                isar: isar,
                log: log,
              ),
            ),
          );
        }
      },
      onLongPress: () {
        onLongPress();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RoundedWhiteCard(
          padding: const EdgeInsets.all(0.0),
          color: isSelected ? kPrimaryColor : null,
          child: ListTile(
            // Date
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateFormat.MMM().format(log.dateTime),
                  style: kDateTextStyle,
                ),
                Text(
                  log.dateTime.day.toString(),
                  style: kDateTextStyle,
                ),
              ],
            ),
            // Piece name
            title: Padding(
              padding: const EdgeInsets.only(
                bottom: 5.0,
              ),
              child: Text(LogHelper.getPieceName(log)),
            ),
            // Ratings
            subtitle: IntrinsicHeight(
              child: Row(
                children: [
                  Text('${log.durationInMin} min'),
                  kVerticalSeparator,
                  Text('$nTickedGoals/$nGoals goals'),
                  RatingBox(
                    rating: log.satisfaction,
                    iconData: kSatisfactionIcon,
                  ),
                  RatingBox(
                    rating: log.focus,
                    iconData: kFocusIcon,
                  ),
                  RatingBox(
                    rating: log.progress,
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
