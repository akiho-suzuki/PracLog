import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/datetime_helpers.dart';
import 'package:praclog_v2/helpers/null_empty_helpers.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/ui/practice/post_practice_screen.dart';
import 'package:praclog_v2/ui/widgets/custom_scaffold.dart';
import 'package:praclog_v2/ui/widgets/goal_card.dart';
import 'package:praclog_v2/ui/widgets/piece_info_tile.dart';
import 'package:praclog_v2/ui/widgets/ratings_tiles.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';
import 'package:praclog_v2/utils/show_popup.dart';

class LogInfoScreen extends StatelessWidget {
  final Log log;
  final Isar isar;
  const LogInfoScreen({
    Key? key,
    required this.isar,
    required this.log,
  }) : super(key: key);

  // Returns a list of goals. Returns an empty widget if there are no goals.
  Widget buildGoalsListWidget(BuildContext context) {
    if (log.goalsList.isNotNullOrEmpty) {
      List<GoalCard> goalCards = log.goalsList!
          .map((goal) => GoalCard(
                goalCardType: GoalCardType.showInLog,
                text: goal.text,
                tickState: goal.isTicked,
              ))
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LogInfoHeaders(text: 'Goals'),
          RoundedWhiteCard(
            child: ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: ListTile.divideTiles(
                  context: context,
                  tiles: goalCards,
                ).toList()),
          ),
          const SizedBox(height: 12.0),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildNotesWidget() {
    return log.notes.isNotNullOrEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LogInfoHeaders(text: 'Notes'),
              RoundedWhiteCard(
                  padding: const EdgeInsets.all(15.0), child: Text(log.notes!)),
            ],
          )
        : const SizedBox.shrink();
  }

  /// Returns `true` if piece was deleted, `false` if cancelled
  Future<bool> onPressDelete(context) async {
    bool? response = await showConfirmPopup(context,
        message: 'Are you sure that you want to delete this log?',
        title: 'Delete log?',
        confirmButtonText: 'Delete');
    if (response == true) {
      await LogDatabase(isar: isar).deleteLog(log);
      return true;
    } else {
      return false;
    }
  }

  Future onPressEdit(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => PostPracticeScreen(
          isar: isar,
          piece: log.piece.value!,
          duration: log.durationInMin!,
          log: log,
          isEdit: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: log.dateTime.getWrittenDate(),
      appBarTrailing: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => onPressEdit(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            bool response = await onPressDelete(context);
            if (response) {
              // Goes back to home screen (log screen)
              if (context.mounted) {
                Navigator.pop(context);
              }
            }
          },
        ),
      ],
      body: ListView(
        children: [
          // Piece info
          const LogInfoHeaders(text: 'Piece info'),
          PieceInfoTile(
            piece: log.piece.value!,
            movementIndex: log.movementIndex,
          ),
          const SizedBox(
            height: 16.0,
          ),
          // Session summary
          const LogInfoHeaders(text: 'Session summary'),
          // Duration
          DurationTile(
              title: 'duration',
              unit: 'minutes',
              data: log.durationInMin.toString()),
          const SizedBox(
            height: 8.0,
          ),
          // Ratings
          RatingsTilesRow(
              satisfaction: log.satisfaction?.toString() ?? '-',
              focus: log.focus?.toString() ?? '-',
              progress: log.progress?.toString() ?? '-'),
          const SizedBox(
            height: 12.0,
          ),
          // Goals
          buildGoalsListWidget(context),
          // Notes
          buildNotesWidget(),
        ],
      ),
    );
  }
}

class LogInfoHeaders extends StatelessWidget {
  final String text;
  const LogInfoHeaders({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: kSubheading),
    );
  }
}
