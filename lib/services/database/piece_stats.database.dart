import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:praclog/custom_error.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/piece_stats.dart';

class PieceStatsDatabase {
  final CollectionReference pieceStatsCollection;
  PieceStatsDatabase(this.pieceStatsCollection);

  CollectionReference get convertedPieceStatsCollection =>
      pieceStatsCollection.withConverter<PieceStats>(
          fromFirestore: (snapshot, _) => PieceStats.fromJson(snapshot.data()!),
          toFirestore: (pieceStats, _) => pieceStats.toJson());

  /// Update pieceStats with the data in the `log`. If the pieceStats does not exist, it will be created. If the log is for a single movement, it will update both the pieceStats for the whole piece and the specific movement.
  Future update(Log log) async {
    await _updatePieceStatsDoc(pieceStatsType: -1, log: log);
    // If the log is for a movement, also update that
    if (log.movementIndex != null) {
      _updatePieceStatsDoc(pieceStatsType: log.movementIndex!, log: log);
    }
  }

  Future _updatePieceStatsDoc(
      {required int pieceStatsType, required Log log}) async {
    var snapshot = await convertedPieceStatsCollection
        .where(Label.pieceStatsType, isEqualTo: pieceStatsType)
        .get();

    try {
      // If pieceStats doc does not exist, create one
      if (snapshot.docs.isEmpty) {
        PieceStats pieceStats = PieceStats.empty(pieceStatsType);
        pieceStats.update(log);
        await convertedPieceStatsCollection.add(pieceStats);
      } else {
        // else update existing doc
        QueryDocumentSnapshot doc = snapshot.docs.first;
        PieceStats pieceStats = doc.data() as PieceStats;
        pieceStats.update(log);
        await convertedPieceStatsCollection.doc(doc.id).set(pieceStats);
      }
    } on FirebaseException catch (e) {
      print(e);
      return e;
    }
  }

  // Remove a log
  Future remove(Log log) async {
    await _removeLogFromPieceStats(pieceStatsType: -1, log: log);
    // If the log is for a movement, also update that
    if (log.movementIndex != null) {
      _removeLogFromPieceStats(pieceStatsType: log.movementIndex!, log: log);
    }
  }

  Future _removeLogFromPieceStats(
      {required int pieceStatsType, required Log log}) async {
    try {
      var snapshot = await convertedPieceStatsCollection
          .where(Label.pieceStatsType, isEqualTo: pieceStatsType)
          .get();

      // Throw exception if document does not exist
      if (snapshot.docs.isEmpty) {
        String movement = pieceStatsType == -1
            ? 'Entire piece'
            : 'Movement $pieceStatsType: ${log.movementTitle ?? '-'}';
        String msg =
            'The piece stats document does not exist. Piece: ${log.composer}: ${log.title} (pieceId: ${log.pieceId}. PieceStatsType: $movement)';
        throw CustomError(msg);
      }

      DocumentSnapshot doc = snapshot.docs.first;
      PieceStats pieceStats = doc.data() as PieceStats;

      // If it's the only log remaining, delete whole doc
      if (pieceStats.nSessions == 1) {
        await pieceStatsCollection.doc(doc.id).delete();
      } else {
        pieceStats.reverse(log);
        await convertedPieceStatsCollection.doc(doc.id).set(pieceStats);
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Delete entire PieceStats collection (for when Piece is deleted)
  Future delete() async {
    var snapshot = await pieceStatsCollection.get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await pieceStatsCollection.doc(doc.id).delete();
    }
  }

  /// Edit: reverseUpdates oldLog then updates newLog
  Future edit(Log oldLog, Log newLog) async {
    try {
      await remove(oldLog);
      await update(newLog);
    } catch (e) {
      print(e);
    }
  }
}
