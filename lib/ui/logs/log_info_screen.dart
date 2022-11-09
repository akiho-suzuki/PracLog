import 'package:flutter/material.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/log_database.dart';
import 'package:praclog/services/database/piece_stats.database.dart';
import 'package:praclog/services/database/repertoire_database.dart';
import 'package:praclog/services/database/week_data_database.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/practice/post_practice_screen.dart';
import 'package:praclog/ui/utils/show_dialog.dart';
import 'package:praclog/ui/widgets/custom_scaffold.dart';
import 'package:praclog/ui/widgets/goal_card.dart';
import 'package:praclog/ui/widgets/piece_info_tile.dart';
import 'package:praclog/ui/widgets/ratings_tiles.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import '../../helpers/null_empty_helper.dart';
import '../../helpers/datetime_helpers.dart';

class LogInfoScreen extends StatelessWidget {
  final Log log;
  const LogInfoScreen({
    Key? key,
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

  void onPressDelete(AuthManager authManager, context) async {
    bool? response = await showConfirmPopup(context,
        message: 'Are you sure that you want to delete this log?',
        title: 'Delete log?',
        confirmButtonText: 'Delete');
    if (response == true) {
      Log.deleteLog(
        log: log,
        logDatabase: LogDatabase(logCollection: authManager.userLogCollection),
        weekDataDatabase: WeekDataDatabase(
            weekDataCollection: authManager.userWeekDataCollection),
        pieceStatsDatabase: PieceStatsDatabase(
            authManager.userPieceStatsCollection(log.pieceId)),
      );
      Navigator.pop(context);
    }
  }

  Future onPressEdit(BuildContext context) async {
    final navigator = Navigator.of(context);
    Piece piece = await RepertoireDatabase(
            repertoireCollection:
                context.read<AuthManager>().userRepertoireCollection)
        .getPieceById(log.pieceId);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => PostPracticeScreen(
          duration: log.durationInMin,
          pieceTitle: piece.title,
          pieceId: piece.id!,
          pieceComposer: piece.composer,
          movement: log.movementIndex,
          oldLog: log,
          isEdit: true,
          movementTitle: log.movementTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: log.date.getWrittenDate(),
      appBarTrailing: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => onPressEdit(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onPressDelete(context.read<AuthManager>(), context),
        )
      ],
      body: ListView(
        children: [
          // Piece info
          const LogInfoHeaders(text: 'Piece info'),
          PieceInfoTile(
            title: log.title,
            composer: log.composer,
            movementIndex: log.movementIndex,
            movementTitle: log.movementTitle,
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
