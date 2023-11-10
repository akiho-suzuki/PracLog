import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/models/log_stats.dart';
import 'package:praclog_v2/utils/show_popup.dart';

/// Repertoire list sorting options (`title` or `composer`)
enum PiecesSortBy { title, composer }

class PiecesDatabase {
  final Isar isar;

  PiecesDatabase({required this.isar});

  // Add a piece
  Future addPiece(
      String title, String composer, List<String>? movements) async {
    final Piece piece = Piece()
      ..composer = composer
      ..title = title
      ..movements = movements
      ..isCurrent = true;

    await isar.writeTxn(() async {
      isar.pieces.put(piece);
    });
  }

  Future deletePiece(Piece piece, BuildContext context) async {
    bool? response = await showConfirmPopup(context,
        message: kDeletePieceMsg,
        title: 'Delete piece?',
        confirmButtonText: 'Delete');
    if (response == true) {
      await isar.writeTxn(
        () async {
          // Load the logs
          await piece.logs.load();
          // Delete all logs (if any)
          if (piece.logs.isNotEmpty) {
            for (Log log in piece.logs) {
              isar.logs.delete(log.id);
            }
          }
          // Delete piece
          await isar.pieces.delete(piece.id);
        },
      );
    }
  }

  /// Updates piece with `editedPiece`.
  ///
  /// Note: Users cannot change the number of movements after initial creation of piece.
  Future editPiece(Piece editedPiece) async {
    await isar.writeTxn(() async => await isar.pieces.put(editedPiece));
  }

  /// Get pieces (as a stream) sorted by chosen option.
  /// Set `showCurrent = false` to show past pieces
  /// (defaults to current pieces)
  Stream<List<Piece>> getSortedPiecesStream(PiecesSortBy sortBy,
      {bool showCurrent = true}) async* {
    Query<Piece> query = sortBy == PiecesSortBy.title
        // Query which sorts by title
        ? isar.pieces
            .where()
            .isCurrentEqualTo(showCurrent)
            .sortByTitle()
            .build()
        // Query which sorts by composer
        : isar.pieces
            .where()
            .isCurrentEqualTo(showCurrent)
            .sortByComposer()
            .build();
    yield* query.watch(fireImmediately: true);
  }

  /// Toggles `isCurrent` property
  Future toggleIsCurrent(Piece piece) async {
    await isar.writeTxn(() async {
      piece.isCurrent = piece.isCurrent ? false : true;
      await isar.pieces.put(piece);
    });
  }

  /// Calculate piece stats for whole piece or a single movement.
  /// `movement` indicates the movement. If `movement == -1`, it means the whole piece
  LogStats getPieceStats(List<Log> logs, int movement) {
    List<Log> logsToCalculate = [];
    // Use all logs if it's for whole piece
    if (movement == -1) {
      logsToCalculate = logs;
    } else {
      // Find all logs that are for chosen movement
      for (Log log in logs) {
        if (log.movementIndex == movement) {
          logsToCalculate.add(log);
        }
      }
    }
    return LogStats.fromLogs(logsToCalculate);
  }
}
