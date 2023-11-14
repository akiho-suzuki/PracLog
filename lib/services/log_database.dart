import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:rxdart/rxdart.dart';

class LogDatabase {
  final Isar isar;

  LogDatabase({required this.isar});

  /// Called when user starts a practice session.
  ///
  /// Saves `piece`, `movement`, `dateTime`, `goalsList`.
  ///
  /// Sets `inProgress` to `true` and `timerDataList` to an empty list.
  Future<Log> startPractice(Piece piece, DateTime dateTime, int? movementIndex,
      List<PracticeGoal> goalsList) async {
    final log = Log()
      ..piece.value = piece
      ..dateTime = dateTime
      ..movementIndex = movementIndex
      ..goalsList = goalsList
      ..timerDataList = []
      ..inProgress = true
      ..completed = false;

    Log? savedLog;

    await isar.writeTxn(() async {
      int id = await isar.logs.put(log);
      await log.piece.save();
      savedLog = await isar.logs.get(id);
    });

    if (savedLog == null) {
      // TODO write message
      throw Error();
    } else {
      return savedLog!;
    }
  }

  /// Called when app sleeps during practice.
  /// Updates `goalsList` and `timerDataList`
  ///
  /// If the user is finishing the practice and going to `PostPracticeScreen`, set `isFinished` to `true`.
  /// This will set `inProgress` to `false` for the log.
  Future midPracticeSave(Log log, List<PracticeGoal> goalsList,
      List<TimerData> timerDataList, bool isFinished) async {
    log
      ..goalsList = goalsList
      ..timerDataList = timerDataList
      ..inProgress = !isFinished;

    await isar.writeTxn(() async => isar.logs.put(log));
  }

  /// Saves full log when practice is complete.
  Future saveLog(Log log) async {
    await isar.writeTxn(() async => isar.logs.put(log));
  }

  // Delete log
  Future deleteLog(Log log) async {
    await isar.writeTxn(() async => await isar.logs.delete(log.id));
  }

  // Get logs between two dates
  Future<List<Log>> getLogsBetween(DateTime startDate, DateTime endDate) async {
    return await isar.logs
        .where()
        .dateTimeBetween(startDate, endDate)
        .findAll();
  }

  // Get logs in batches
  Future<List<Log>> getLogsInBatches(int offset, int limit) async {
    List<Log> logs = await isar.logs
        .where()
        .completedEqualTo(true)
        .sortByDateTimeDesc()
        .offset(offset)
        .limit(limit)
        .findAll();

    // Load the piece info
    for (Log log in logs) {
      await log.piece.load();
    }
    return logs;
  }

  /// Returns a stream of logs between `start` and `end` DateTimes.
  Stream<List<Log>> getWeekLogStream(DateTime start, DateTime end) async* {
    Query<Log> query =
        isar.logs.where(sort: Sort.asc).dateTimeBetween(start, end).build();
    yield* query.watch(fireImmediately: true);
  }

  /// Fires when there is a change in the logs or pieces.
  /// (Pieces are watched separately and combined as the isar watcher does not detect changes in linked objects)
  Stream<void> watchLogListChanges() async* {
    Query logQuery = isar.logs.where().completedEqualTo(true).build();
    Stream<void> logChangeWatcher = logQuery.watchLazy();
    final Stream<void> piecesChangeWatcher = isar.pieces.watchLazy();
    yield* CombineLatestStream(
        [logChangeWatcher, piecesChangeWatcher], ((_) {}));
  }
}
