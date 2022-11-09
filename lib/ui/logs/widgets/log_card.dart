import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/logs/log_info_screen.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';

// The LogCard widget
class LogCard extends StatelessWidget {
  final Log log;
  final bool isSelected;
  final bool multipleDeleteMode;
  final VoidCallback onLongPress;
  final VoidCallback onTapInMultipleDelete;

  const LogCard({
    Key? key,
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
          // Piece piece = await UserDatabase(
          //         FirebaseFirestore.instance
          //             .collection(Label.users),
          //         FirebaseAuth.instance.currentUser)
          //     .repertoireDatabase
          //     .getPieceById(log.pieceId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogInfoScreen(
                //piece: piece,
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
          color: isSelected ? CustomColors.primaryColor : null,
          child: ListTile(
            // Date
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateFormat.MMM().format(log.date),
                  style: kDateTextStyle,
                ),
                Text(
                  log.date.day.toString(),
                  style: kDateTextStyle,
                ),
              ],
            ),
            // Piece name
            title: Padding(
              padding: const EdgeInsets.only(
                bottom: 5.0,
              ),
              child: Text(
                '${log.composer}: ${log.title}',
                // style: const TextStyle(
                //   fontSize: 18.0,
                //fontWeight: FontWeight.w600,
                //  ),
              ),
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
