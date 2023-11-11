import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/helpers/datetime_helpers.dart';
import 'package:share_plus/share_plus.dart';

class DataImportExport {
  final Isar isar;

  DataImportExport({required this.isar});

  // Gets path to store file (with file name)
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/pracLogData_${DateTime.now()}";
  }

  /// Exports data as json file that can be shared.
  ///
  /// If `dateTimeRange` is `null`, it will export the entire dataset.
  ///
  /// Returns `true` if data shared succesfully; otherwise returns `false`.
  Future<bool> exportData(DateTimeRange? dateTimeRange) async {
    Query<Log> logQuery;
    Query<Piece> pieceQuery;
    pieceQuery = isar.pieces.where().build();

    // For exporting all data
    if (dateTimeRange == null) {
      logQuery = isar.logs.where().sortByDateTime().build();
    } else {
      // For exporting data within dateTimeRange
      DateTime startDate = dateTimeRange.start.setAtStartOfDay();
      DateTime endDate = dateTimeRange.end.setAtEndOfDay();
      logQuery = isar.logs.where().dateTimeBetween(startDate, endDate).build();
    }

    // Get json data for pieces and logs
    List<Map<String, dynamic>> logJson = await logQuery.exportJson();
    List<Map<String, dynamic>> pieceJson = await pieceQuery.exportJson();

    // Put log and piece data into one json
    _CollectionMerger mergedData =
        _CollectionMerger(logData: logJson, pieceData: pieceJson);
    Map<String, dynamic> mergedJson = mergedData.toJson();
    String jsonString = jsonEncode(mergedJson);

    // Get the file where data will be written.
    String filePath = await _getFilePath();
    final file = File(filePath);

    // Write data
    await file.writeAsString(jsonString);

    // Share it
    final result =
        await Share.shareXFiles([XFile(filePath)], text: 'PracLog data');
    return result.status == ShareResultStatus.success ? true : false;
  }

  // TODO: implement in app (currently not used or tested)
  Future importData(String json) async {
    Map<String, dynamic> jsonMap = jsonDecode(json) as Map<String, dynamic>;
    _CollectionMerger collectionMerger = _CollectionMerger.fromJson(jsonMap);
    await isar.writeTxn(() async {
      // Clear the database
      await isar.logs.clear();
      await isar.pieces.clear();
      // Import data
      await isar.logs.importJson(collectionMerger.logData);
      await isar.logs.importJson(collectionMerger.pieceData);
    });
  }
}

class _CollectionMerger {
  List<Map<String, dynamic>> pieceData;
  List<Map<String, dynamic>> logData;

  static const String _pieces = "pieces";
  static const String _logs = "logs";

  _CollectionMerger({required this.pieceData, required this.logData});

  Map<String, dynamic> toJson() => {_pieces: pieceData, _logs: logData};

  _CollectionMerger.fromJson(Map<String, dynamic> json)
      : pieceData = json[_pieces],
        logData = json[_logs];
}
