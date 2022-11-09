import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/piece.dart';
import '../../helpers/datetime_helpers.dart';

class LogDatabase {
  CollectionReference logCollection;
  LogDatabase({required this.logCollection});

  CollectionReference get convertedLogCollection =>
      logCollection.withConverter<Log>(
          fromFirestore: (snapshot, _) =>
              Log.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (log, _) => log.toJson());

  /// Adds log to the user's log collection on Firestore
  Future addLog(Log log) async {
    try {
      return await convertedLogCollection.add(log);
    } catch (e) {
      return e;
    }
  }

  // Deletes the log from Firestore
  Future deleteLog(Log log) async {
    try {
      await logCollection.doc(log.id).delete();
    } catch (e) {
      print(e);
    }
  }

  /// Update log
  Future editLog(Log log) async {
    try {
      await convertedLogCollection.doc(log.id).set(log);
    } catch (e) {
      print(e);
    }
  }

  /// Delete all logs associated with a piece (for when the piece is deleted).
  /// Returns the list of logs that were deleted.
  Future<List<Log>> deleteLogsForPiece(Piece piece) async {
    QuerySnapshot snapshot =
        await logCollection.where(Label.pieceId, isEqualTo: piece.id).get();
    List<Log> logs = _getLogsFromSnapshot(snapshot);
    for (Log log in logs) {
      logCollection.doc(log.id).delete();
    }
    return logs;
  }

  /// Edit just the piece info in logs when piece is updated
  // TODO make more efficient for Firestore by only setting the relevant documents if only movements are changed
  Future updatePieceInfo(Piece updatedPiece) async {
    QuerySnapshot snapshot = await logCollection
        .where(Label.pieceId, isEqualTo: updatedPiece.id)
        .get();
    List<Log> logs = _getLogsFromSnapshot(snapshot);

    for (Log log in logs) {
      try {
        // If log is for a movement, update title, composer, movementTitle
        if (log.movementIndex != null) {
          await convertedLogCollection.doc(log.id).update({
            Label.composer: updatedPiece.composer,
            Label.title: updatedPiece.title,
            Label.movementTitle: updatedPiece.movements![log.movementIndex!],
          });
        } else {
          // Only update title and composer
          await convertedLogCollection.doc(log.id).update({
            Label.composer: updatedPiece.composer,
            Label.title: updatedPiece.title,
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  // Turn snapshot into a log
  List<Log> _getLogsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Log.fromJson(doc.id, doc.data() as Map<String, Object?>))
        .toList();
  }

  /// Get log stream
  Stream<List<Log>> get logStream => logCollection
      .snapshots()
      .map((snapshot) => _getLogsFromSnapshot(snapshot));

  /// Get all logs between two dates
  Future<List<Log>?> getAllLogsBetween(DateTime from, DateTime to) async {
    DateTime fromDate = from.setAtStartOfDay();
    DateTime toDate = to.add(const Duration(days: 1)).setAtStartOfDay();
    if (fromDate.isAfter(toDate)) {
      throw ArgumentError('From date must be equal to or less than to date');
    }

    try {
      QuerySnapshot snapshot = await logCollection
          .where(Label.date, isGreaterThanOrEqualTo: fromDate)
          .where(Label.date, isLessThanOrEqualTo: toDate)
          .get();
      return _getLogsFromSnapshot(snapshot);
    } catch (e, stacktrace) {
      await FirebaseCrashlytics.instance
          .recordError(e, stacktrace, reason: 'a non-fatal error');
      return null;
    }
  }
}
