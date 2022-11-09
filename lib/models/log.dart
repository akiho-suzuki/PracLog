import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/services/database/log_database.dart';
import 'package:praclog/services/database/piece_stats.database.dart';
import 'package:praclog/services/database/week_data_database.dart';
import '../helpers/datetime_helpers.dart';

class Log {
  // For CSV file names
  static const String logsData = 'logsData';
  static const String goalsData = 'goalsData';

  final String? id;
  final String pieceId;
  final String composer;
  final String title;
  final int? movementIndex;
  final String? movementTitle;
  final DateTime date;
  final int durationInMin;
  final List<PracticeGoal>? goalsList;
  final int? focus;
  final int? progress;
  final int? satisfaction;
  final String? notes;

  Log({
    required this.pieceId,
    required this.composer,
    required this.title,
    required this.date,
    required this.durationInMin,
    this.goalsList,
    this.focus,
    this.progress,
    this.satisfaction,
    this.notes,
    this.id,
    this.movementIndex,
    this.movementTitle,
  });

  String get weekStartDate => date.getWeekStart().getDateOnly();

  /// Turns practice goals into maps {goalText : isTicked} to store on Firestore
  Map<String, bool>? get goalsAsMap {
    if (goalsList != null && goalsList!.isNotEmpty) {
      Map<String, bool> map = {};
      for (PracticeGoal goal in goalsList!) {
        map[goal.text] = goal.isTicked;
      }
      return map;
    } else {
      return null;
    }
  }

  /// Turns goals map from Firestore into a list of Goal objects
  static List<PracticeGoal>? getGoalsListFromFirestoreMap(
      Map<String, dynamic>? goalMap) {
    if (goalMap != null && goalMap.isNotEmpty) {
      List<PracticeGoal> list = [];
      goalMap.forEach((goalText, isTicked) {
        list.add(PracticeGoal(text: goalText, isTicked: isTicked));
      });
      return list;
    } else {
      return null;
    }
  }

  Log.fromJson(String id, Map<String, Object?> json)
      : this(
          id: id,
          pieceId: json[Label.pieceId] as String,
          title: json[Label.title] as String,
          composer: json[Label.composer] as String,
          movementIndex: json[Label.movementIndex] as int?,
          movementTitle: json[Label.movementTitle] as String?,
          satisfaction: json[Label.satisfaction] as int?,
          focus: json[Label.focus] as int?,
          progress: json[Label.progress] as int?,
          date: (json[Label.date] as Timestamp).toDate(),
          durationInMin: json[Label.durationInMin] as int,
          goalsList: getGoalsListFromFirestoreMap(
              json[Label.goals] as Map<String, dynamic>?),
          notes: json[Label.notes] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      Label.pieceId: pieceId,
      Label.composer: composer,
      Label.title: title,
      Label.movementIndex: movementIndex,
      Label.movementTitle: movementTitle,
      Label.durationInMin: durationInMin,
      Label.date: date,
      Label.goals: goalsAsMap,
      Label.focus: focus,
      Label.satisfaction: satisfaction,
      Label.progress: progress,
      Label.notes: notes,
      // This is stored in Firestore to help with finding all logs associated with a WeekData
      // Note: it is not read in toJson because it can be calculated from the date
      Label.weekStartDate: weekStartDate,
    };
  }

  List _convertToDataList() {
    return [
      id,
      date,
      pieceId,
      composer,
      title,
      movementIndex,
      movementTitle,
      durationInMin,
      satisfaction,
      progress,
      focus,
      notes
    ];
  }

  /// Returns a map with two values. `logsData` contains data for the logs. `goalsData` contains data for the goals, referenced to the relevant log by logId
  ///
  /// Log data contains 12 columns:
  /// id,
  /// date,
  /// pieceId,
  /// composer,
  /// title,
  /// movementIndex,
  /// movementTitle,
  /// durationInMin,
  /// satisfaction,
  /// progress,
  /// focus,
  /// notes
  ///
  /// Goals data contains 3 columns: id, text, isTicked
  static Map<String, List<List>> convertToDatalistList(List<Log> logs) {
    List<List> logsDataList = [];
    List<List> goalsDataList = [];

    for (Log log in logs) {
      logsDataList.add(log._convertToDataList());
      if (log.goalsList != null && log.goalsList!.isNotEmpty) {
        for (PracticeGoal goal in log.goalsList!) {
          goalsDataList.add([log.id, goal.text, goal.isTicked]);
        }
      }
    }
    return {logsData: logsDataList, goalsData: goalsDataList};
  }

  /// Adds log and all updates other associated data
  static Future addLog(
      {required Log log,
      required LogDatabase logDatabase,
      required WeekDataDatabase weekDataDatabase,
      required PieceStatsDatabase pieceStatsDatabase}) async {
    // Add log
    await logDatabase.addLog(log);
    // Update weekDataDatabase
    await weekDataDatabase.addLog(log);
    // Update piece stats
    await pieceStatsDatabase.update(log);
  }

  /// Deletes log and all updates other associated data
  static Future deleteLog(
      {required Log log,
      required LogDatabase logDatabase,
      required WeekDataDatabase weekDataDatabase,
      required PieceStatsDatabase pieceStatsDatabase}) async {
    // Delete log
    await logDatabase.deleteLog(log);
    // Update weekDataDatabase
    await weekDataDatabase.deleteLog(log);
    // Update piece stats
    await pieceStatsDatabase.remove(log);
  }

  /// Edits log and all other associated data that needs to be updated
  static Future editLog(
      {required Log newLog,
      required Log oldLog,
      required LogDatabase logDatabase,
      required WeekDataDatabase weekDataDatabase,
      required PieceStatsDatabase pieceStatsDatabase}) async {
    // Edit log
    await logDatabase.editLog(newLog);
    // Update piece stats
    await pieceStatsDatabase.edit(oldLog, newLog);
    // Update piece stats
    await weekDataDatabase.editLog(oldLog, newLog);
  }
}
