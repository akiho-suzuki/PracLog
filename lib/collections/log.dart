import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/piece.dart';

part 'log.g.dart';

@Collection()
class Log {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime dateTime;

  // Progress information
  /// If `true` it means that the session has finished and now in log list
  @Index()
  late bool completed;

  /// If `true` it means that the user is currently in middle of practising.
  /// (i.e. on `PracticeScreen)
  late bool inProgress;

  // Repertoire information
  final piece = IsarLink<Piece>();
  int? movementIndex;

  // Goals
  List<PracticeGoal>? goalsList;

  // Timer information
  late List<TimerData> timerDataList;
  int? durationInMin;

  // Post-practice information
  int? focus;
  int? progress;
  int? satisfaction;
  String? notes;
}

@embedded
class TimerData {
  late DateTime startTime;
  DateTime? endTime;
}

@embedded
class PracticeGoal {
  late String text;
  late bool isTicked;
}
