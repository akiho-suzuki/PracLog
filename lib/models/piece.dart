import 'package:flutter/material.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/services/database/log_database.dart';
import 'package:praclog/services/database/repertoire_database.dart';
import 'package:praclog/services/database/week_data_database.dart';
import 'package:praclog/ui/utils/show_dialog.dart';
import '../helpers/label.dart';
import '../helpers/null_empty_helper.dart';

/// Holds information for a piece in the user's repertoire.
class Piece {
  String? id;
  String title;
  String composer;
  List<String>? movements;
  bool isCurrent;

  Piece({
    required this.title,
    required this.composer,
    this.id,
    this.movements,
    this.isCurrent = true,
  });

  static List<String>? _getMovementList(List<dynamic>? jsonList) {
    List<String>? list = [];
    if (jsonList.isNotNullOrEmpty) {
      for (dynamic item in jsonList!) {
        list.add(item.toString());
      }
    }
    return list;
  }

  Piece.fromJson(String id, Map<String, Object?> json)
      : this(
          id: id,
          title: json[Label.title] as String,
          composer: json[Label.composer] as String,
          movements: _getMovementList(json[Label.movements] as List<dynamic>?),
          isCurrent: json[Label.isCurrent] as bool,
        );

  Map<String, Object?> toJson() {
    return {
      Label.title: title,
      Label.composer: composer,
      Label.movements: movements,
      Label.isCurrent: isCurrent,
    };
  }

  @override
  String toString() {
    return '$composer: $title';
  }

  static Future editPiece({
    required Piece piece,
    required RepertoireDatabase repertoireDatabase,
    required LogDatabase logDatabase,
  }) async {
    // Edit piece on Firestore
    await repertoireDatabase.editPiece(piece);
    // Edit piece details on all logs for that piece
    await logDatabase.updatePieceInfo(piece);
  }

  static Future deletePiece({
    required BuildContext context,
    required Piece piece,
    required RepertoireDatabase repertoireDatabase,
    required LogDatabase logDatabase,
    required WeekDataDatabase weekDataDatabase,
  }) async {
    bool? response = await showConfirmPopup(context,
        message: kDeletePieceMsg,
        title: 'Delete piece?',
        confirmButtonText: 'Delete');
    if (response == true) {
      // Delete piece
      await repertoireDatabase.deletePiece(piece);
      // TODO batch so that logs and weekDatabase are both definitely updated
      // Delete all logs for the piece
      List<Log> logs = await logDatabase.deleteLogsForPiece(piece);
      // Update WeekData
      await weekDataDatabase.updateForMultipleLogDelete(logs);
    }
  }
}
