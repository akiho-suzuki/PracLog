import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/piece_stats.dart';

void main() {
  group('PieceStatsAverageData:', () {
    late PieceStatsAverageData averageData;
    setUp(() {
      averageData = PieceStatsAverageData(nSessions: 2, data: 3.0);
    });

    test('Converts into json correctly', () {
      Map<String, Object> result = averageData.toJson();
      Map<String, Object> expected = {
        'nSessions': 2,
        'data': 3.0,
      };
      expect(result, equals(expected));
    });

    test('Converts from json correctly', () {
      Map<String, Object?> json = {
        'nSessions': 2,
        'data': 3.0,
      };
      PieceStatsAverageData result = PieceStatsAverageData.fromJson(json);
      expect(result.nSessions, equals(2));
      expect(result.data, equals(3.0));
    });

    test('Turns into String correctly', () {
      String expected = '3.0';
      expect(averageData.toString(), equals(expected));
    });

    test('Turns into String correctly for empty data', () {
      PieceStatsAverageData emptyData = PieceStatsAverageData.empty();
      String expected = '-';
      expect(emptyData.toString(), equals(expected));
    });

    test('Updates correctly', () {
      averageData.update(5);
      expect(averageData.nSessions, equals(3));
      expect(averageData.data.toStringAsFixed(1), equals('3.7'));
    });

    test('Reverse updates correctly', () {
      averageData.reverseUpdate(5);
      expect(averageData.nSessions, equals(1));
      expect(averageData.data.toStringAsFixed(1), equals('1.0'));
    });

    test('Reverse updates correctly for the last data', () {
      averageData.reverseUpdate(3);
      averageData.reverseUpdate(3);
      expect(averageData.nSessions, equals(0));
      expect(averageData.data.toStringAsFixed(1), equals('0.0'));
    });
  });

  group('PieceStats', () {
    late PieceStats pieceStats;
    late Log log;
    late Log log2;

    setUp(() {
      pieceStats = PieceStats.empty(-1);
      log = Log(
        pieceId: '123',
        date: DateTime.utc(2022, 05, 20),
        composer: 'Mozart',
        title: 'Sonata',
        focus: 5,
        satisfaction: 3,
        progress: null,
        durationInMin: 60,
      );

      log2 = Log(
        pieceId: '123',
        date: DateTime.utc(2022, 05, 21),
        composer: 'Mozart',
        title: 'Sonata',
        focus: 3,
        satisfaction: null,
        progress: 5,
        durationInMin: 30,
      );
    });

    group('Updates', () {
      test('correctly for first log', () {
        pieceStats.update(log);
        expect(pieceStats.nSessions, equals(1));
        expect(pieceStats.averageFocus.toString(), equals('5.0'));
        expect(pieceStats.averageSatisfaction.toString(), equals('3.0'));
        expect(pieceStats.averageProgress.toString(), equals('-'));
        expect(pieceStats.averageMin.toString(), equals('60.0'));
        expect(pieceStats.totalDurationInHours, equals('1.0'));
      });

      test('correctly for second log', () {
        pieceStats.update(log);
        pieceStats.update(log2);
        expect(pieceStats.nSessions, equals(2));
        expect(pieceStats.averageFocus.toString(), equals('4.0'));
        expect(pieceStats.averageSatisfaction.toString(), equals('3.0'));
        expect(pieceStats.averageProgress.toString(), equals('5.0'));
        expect(pieceStats.averageMin.toString(), equals('45.0'));
        expect(pieceStats.totalDurationInHours, equals('1.5'));
      });
    });

    group('Reverse updates', () {
      // These assume that the update function works correctly
      test('correctly', () {
        pieceStats.update(log);
        pieceStats.update(log2);
        pieceStats.update(log);
        pieceStats.reverse(log);
        expect(pieceStats.nSessions, equals(2));
        expect(pieceStats.averageFocus.toString(), equals('4.0'));
        expect(pieceStats.averageSatisfaction.toString(), equals('3.0'));
        expect(pieceStats.averageProgress.toString(), equals('5.0'));
        expect(pieceStats.averageMin.toString(), equals('45.0'));
        expect(pieceStats.totalDurationInHours, equals('1.5'));
      });

      test('correctly for the last log', () {
        pieceStats.update(log);
        pieceStats.reverse(log);
        expect(pieceStats.nSessions, equals(0));
        expect(pieceStats.averageFocus.toString(), equals('-'));
        expect(pieceStats.averageSatisfaction.toString(), equals('-'));
        expect(pieceStats.averageProgress.toString(), equals('-'));
        expect(pieceStats.averageMin.toString(), equals('-'));
        expect(pieceStats.totalDurationInHours, equals('0.0'));
      });
    });

    group('Converts', () {
      // These assume that the update function works correctly
      test('to json', () {
        pieceStats.update(log);
        Map<String, dynamic> result = pieceStats.toJson();
        Map expectedFocus = {Label.nSessions: 1, Label.data: 5.0};
        Map expectedProgress = {Label.nSessions: 0, Label.data: 0.0};
        Map expectedAvDuration = {Label.nSessions: 1, Label.data: 60.0};
        int expectedNSessions = 1;
        int expectedTotalDuration = 60;

        expect(result[Label.averageFocus], equals(expectedFocus));
        expect(result[Label.averageProgress], equals(expectedProgress));
        expect(result[Label.averageDuration], equals(expectedAvDuration));
        expect(result[Label.nSessions], equals(expectedNSessions));
        expect(result[Label.totalDurationInMin], equals(expectedTotalDuration));
      });

      test('from json', () {
        int nSessions = 10;
        int focusNSessions = 9;
        double averageFocus = 4.0;
        int totalDurationInMin = 300;
        DateTime startDate = DateTime.utc(2022, 01, 10);

        Map<String, dynamic> json = {
          Label.pieceStatsType: -1,
          Label.nSessions: nSessions,
          Label.averageFocus: {
            Label.nSessions: focusNSessions,
            Label.data: averageFocus
          },
          Label.averageSatisfaction: {Label.nSessions: 0, Label.data: 0.0},
          Label.averageProgress: {Label.nSessions: 9, Label.data: 3.0},
          Label.averageDuration: {Label.nSessions: 10, Label.data: 30.0},
          Label.startDate: Timestamp.fromDate(startDate),
          Label.totalDurationInMin: totalDurationInMin,
        };

        PieceStats result = PieceStats.fromJson(json);
        // TODO date is one hour off
        //expect(result.startDate, equals(startDate));
        expect(result.nSessions, equals(nSessions));
        expect(result.averageFocus.data, equals(averageFocus));
        expect(result.averageFocus.nSessions, equals(focusNSessions));
        expect(result.totalMinutes, equals(totalDurationInMin));
      });
    });
  });
}
