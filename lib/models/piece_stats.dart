import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:praclog/custom_error.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import '../helpers/datetime_helpers.dart';

/// Class that holds current average and number of data points that form that average
class PieceStatsAverageData {
  int nSessions;
  double data;
  PieceStatsAverageData({required this.nSessions, required this.data});
  PieceStatsAverageData.empty() : this(nSessions: 0, data: 0.0);

  Map<String, Object> toJson() {
    return {
      Label.nSessions: nSessions,
      Label.data: data,
    };
  }

  PieceStatsAverageData.fromJson(Map<String, Object?> json)
      : this(
          nSessions: json[Label.nSessions] as int,
          data: json[Label.data] as double,
        );

  @override
  String toString() {
    return data == 0.0 ? '-' : data.toStringAsFixed(1);
  }

  void update(int? newData) {
    if (newData != null) {
      data = ((data * nSessions) + newData) / (nSessions + 1);
      nSessions++;
    }
  }

  void reverseUpdate(int? dataToRemove) {
    if (dataToRemove != null) {
      if (nSessions == 0) {
        throw CustomError('Cannot remove from empty data');
      }
      // If it's the last session
      if (nSessions == 1) {
        if (data - dataToRemove != 0) {
          throw CustomError('Existing data and dataToRemove do not match');
        } else {
          nSessions = 0;
          data = 0.0;
        }
      } else {
        data = ((data * nSessions) - dataToRemove) / (nSessions - 1);
        nSessions--;
      }
    }
  }
}

class PieceStats {
  /// `pieceStatsType = -1` if for the whole piece, or movement index number if it's for a movement
  int pieceStatsType;
  int nSessions;
  DateTime? startDate;
  int totalMinutes;
  PieceStatsAverageData averageMin;
  PieceStatsAverageData averageFocus;
  PieceStatsAverageData averageProgress;
  PieceStatsAverageData averageSatisfaction;

  // Get functions
  String get averageMinAsString => averageMin.toString();
  String get averageFocusAsString => averageFocus.toString();
  String get averageProgressAsString => averageProgress.toString();
  String get averageSatisfactionAsString => averageSatisfaction.toString();
  String get daysSinceLearning =>
      startDate?.numberOfDaysBetween(DateTime.now()).toString() ?? '-';
  String get totalDurationInHours => (totalMinutes / 60).toStringAsFixed(1);

  PieceStats.empty(this.pieceStatsType)
      : nSessions = 0,
        totalMinutes = 0,
        averageFocus = PieceStatsAverageData.empty(),
        averageMin = PieceStatsAverageData.empty(),
        averageProgress = PieceStatsAverageData.empty(),
        averageSatisfaction = PieceStatsAverageData.empty();

  PieceStats.fromJson(Map<String, Object?> json)
      : pieceStatsType = json[Label.pieceStatsType] as int,
        nSessions = json[Label.nSessions] as int,
        totalMinutes = json[Label.totalDurationInMin] as int,
        startDate = (json[Label.startDate] as Timestamp).toDate(),
        averageFocus = PieceStatsAverageData.fromJson(
            json[Label.averageFocus] as Map<String, Object?>),
        averageProgress = PieceStatsAverageData.fromJson(
            json[Label.averageProgress] as Map<String, Object?>),
        averageSatisfaction = PieceStatsAverageData.fromJson(
            json[Label.averageSatisfaction] as Map<String, Object?>),
        averageMin = PieceStatsAverageData.fromJson(
            json[Label.averageDuration] as Map<String, Object?>);

// If writing to Firestore, startDate cannot be null.
  Map<String, dynamic> toJson() {
    if (startDate == null) {
      throw Exception('Start date cannot be null to write to Firestore');
    }
    return {
      Label.pieceStatsType: pieceStatsType,
      Label.nSessions: nSessions,
      Label.totalDurationInMin: totalMinutes,
      Label.startDate: startDate,
      Label.averageFocus: averageFocus.toJson(),
      Label.averageProgress: averageProgress.toJson(),
      Label.averageSatisfaction: averageSatisfaction.toJson(),
      Label.averageDuration: averageMin.toJson(),
    };
  }

  void update(Log log) {
    startDate ??= log.date;
    averageFocus.update(log.focus);
    averageProgress.update(log.progress);
    averageSatisfaction.update(log.satisfaction);
    averageMin.update(log.durationInMin);
    nSessions++;
    totalMinutes += log.durationInMin;
  }

  void reverse(Log log) {
    if (startDate == null) {
      throw Exception(
          'Piece stats cannot be reversed if the start date is null');
    } else {
      // Check if startDate needs to be adjusted
    }

    averageFocus.reverseUpdate(log.focus);
    averageProgress.reverseUpdate(log.progress);
    averageSatisfaction.reverseUpdate(log.satisfaction);
    averageMin.reverseUpdate(log.durationInMin);
    totalMinutes -= log.durationInMin;
    nSessions--;
  }
}
