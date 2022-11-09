import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/models/graph_data.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/week_data.dart';
import '../test_data.dart';

void main() {
  late WeekData weekData;
  late List<WeekData> oneWeek;
  late List<WeekData> twoWeeks;
  late List<WeekData> fourWeeks;
  late List<WeekData> fiveWeeks;

  setUp(() {
    weekData = WeekData.emptyStats(weekStartDate: testWeekStartDate);
    fiveWeeks = inputMonthDummyData();
    fourWeeks = inputMonthDummyData();
    fourWeeks.removeLast();
    twoWeeks = inputMonthDummyData().sublist(0, 2);
    oneWeek = [inputMonthDummyData().first];
  });

  group('Updates', () {
    test('correctly for first log of week and day', () {
      Log testLog = generateLog1(DateTime.utc(2022, 05, 24));
      weekData.update(testLog);

      expect(weekData.focusList.tue, equals([focus1]));
      expect(weekData.progressList.tue, equals([progress1]));
      expect(weekData.satisfactionList.tue, equals([0]));
      expect(weekData.nSessionsList['tue'], equals(1));
      expect(weekData.durationsList.tue, equals([duration1]));
    });

    test('correctly for second log of a day', () {
      // Note: this test assumes that the previous test has passed.
      Log testLog1 = generateLog1(DateTime.utc(2022, 05, 24));
      Log testLog2 = generateLog2(DateTime.utc(2022, 05, 24));
      weekData.update(testLog1);
      weekData.update(testLog2);

      expect(weekData.focusList.tue, equals([focus1, focus2]));
      expect(weekData.progressList.tue, equals([progress1, progress2]));
      expect(weekData.satisfactionList.tue, equals([0, satisfaction2]));
      expect(weekData.nSessionsList['tue'], equals(2));
      expect(weekData.durationsList.tue, equals([duration1, duration2]));
    });

    test('correctly for subsequent logs of week', () {
      // Note: this test assumes that first test has passed.
      Log testLog1 = generateLog1(DateTime.utc(2022, 05, 24));
      Log testLog2 = generateLog2(DateTime.utc(2022, 05, 26));
      weekData.update(testLog1);
      weekData.update(testLog2);

      expect(weekData.focusList.thu, equals([focus2]));
      expect(weekData.progressList.thu, equals([progress2]));
      expect(weekData.satisfactionList.thu, equals([satisfaction2]));
      expect(weekData.nSessionsList['thu'], equals(1));
      expect(weekData.durationsList.thu, equals([duration2]));
    });

    test('reversely correctly', () {
      // Note: this test assumes that previous tests have passed.
      Log testLog1 = generateLog1(DateTime.utc(2022, 05, 24));
      Log testLog2 = generateLog2(DateTime.utc(2022, 05, 26));
      weekData.update(testLog1);
      weekData.update(testLog2);
      weekData.update(testLog1, reverseUpdate: true);

      expect(weekData.focusList.tue, equals([]));
      expect(weekData.progressList.tue, equals([]));
      expect(weekData.satisfactionList.tue, equals([]));
      expect(weekData.nSessionsList['tue'], equals(0));
      expect(weekData.durationsList.tue, equals([]));

      expect(weekData.focusList.thu, equals([focus2]));
      expect(weekData.progressList.thu, equals([progress2]));
      expect(weekData.satisfactionList.thu, equals([satisfaction2]));
      expect(weekData.nSessionsList['thu'], equals(1));
      expect(weekData.durationsList.thu, equals([duration2]));
    });

    test('throws error if log date does not match the WeekData week', () {
      Log testLog = generateLog2(DateTime.utc(2022, 06, 13));
      expect(() {
        weekData.update(testLog);
      }, throwsArgumentError);
    });
  });

  group('Aggregate data:', () {
    // Note these tests assume that the previous 'updates' tests have passed
    setUp(() {
      inputDummyWeekData(weekData);
    });

    test('Returns correct averages list', () {
      expect(weekData.focusList.averageList, equals(expectedFocusListAverages));
    });

    test('Returns correct total nSessions', () {
      expect(weekData.nSessionsList, equals(expectedNSessionsList));
    });

    test('Returns correct daily totals', () {
      expect(weekData.durationsList.dayTotal, expectedDurationTotals);
    });
  });

  group('Generates 7 day graph data', () {
    group('for ratings', () {
      test('correctly for Sunday', () {
        RatingsGraphData result = WeekData.generateRatingsGraphData(
            oneWeek, DateTime.sunday, GraphDateType.last7Days);
        expect(result.focusRatings, [
          focus1double,
          focus12average,
          focus2double,
          (focus1 + focus2 + focus1) / 3,
          focus2double,
          focus1double,
          focus2double,
        ]);
      });

      test('correctly for a non-Sunday', () {
        RatingsGraphData result = WeekData.generateRatingsGraphData(
            twoWeeks, DateTime.wednesday, GraphDateType.last7Days);
        expect(result.focusRatings, [
          (focus1 + focus2 + focus1) / 3,
          focus2double,
          focus1double,
          focus2double,
          focus12average,
          0.0,
          focus12average,
        ]);
      });
    });

    group('for duration', () {
      test('correctly for Sunday', () {
        DurationGraphData result = WeekData.generateDurationGraphData(
            oneWeek, DateTime.sunday, GraphDateType.last7Days);
        expect(result.dayTotals, [
          duration1double,
          duration12total,
          duration2double,
          duration12total + duration1,
          duration2double,
          duration1double,
          duration2double,
        ]);
      });

      test('correctly for a non-Sunday', () {
        DurationGraphData result = WeekData.generateDurationGraphData(
            twoWeeks, DateTime.wednesday, GraphDateType.last7Days);
        expect(result.dayTotals, [
          duration12total + duration1,
          duration2double,
          duration1double,
          duration2double,
          duration12total,
          0.0,
          duration12total
        ]);
      });

      test('raises exception if length is not 1 for Sunday', () {
        expect(() {
          WeekData.generateDurationGraphData(
              twoWeeks, DateTime.sunday, GraphDateType.last7Days);
        }, throwsArgumentError);
      });

      test('raises exception if length is not 2 for non-Sunday', () {
        expect(() {
          WeekData.generateDurationGraphData(
              oneWeek, DateTime.wednesday, GraphDateType.last7Days);
        }, throwsArgumentError);
      });
    });
  });

  group('Generates 28 day graph data', () {
    group('for ratings:', () {
      test('correctly for Sunday', () {
        RatingsGraphData result = WeekData.generateRatingsGraphData(
            fourWeeks, DateTime.sunday, GraphDateType.last28Days);
        expect(result.focusRatings.length, equals(28));
        expect(result.focusRatings[0], equals(focus1double));
        expect(result.focusRatings[2], equals(focus2double));
        expect(result.focusRatings[1], equals(focus12average));
        expect(result.focusRatings[18], equals(0.0));
      });

      test('correctly for non-Sunday', () {
        RatingsGraphData result = WeekData.generateRatingsGraphData(
            fiveWeeks, DateTime.tuesday, GraphDateType.last28Days);
        expect(result.focusRatings.length, equals(28));
        expect(result.focusRatings[0], equals(focus2double));
        expect(result.focusRatings[3], equals(focus1double));
        expect(result.focusRatings[23], equals(focus12average));
        expect(result.focusRatings[14], equals(0.0));
      });

      test('raises exception if data length is not 4 for a Sunday', () {
        expect(() {
          WeekData.generateRatingsGraphData(
              fiveWeeks, DateTime.sunday, GraphDateType.last28Days);
        }, throwsArgumentError);
      });

      test('raises exception if data length is not 5 for a non-Sunday', () {
        expect(() {
          WeekData.generateRatingsGraphData(
              fourWeeks, DateTime.tuesday, GraphDateType.last28Days);
        }, throwsArgumentError);
      });
    });

    group('for duration:', () {
      test('correctly for Sunday', () {
        DurationGraphData result = WeekData.generateDurationGraphData(
            fourWeeks, DateTime.sunday, GraphDateType.last28Days);
        double duration1Double = duration1.toDouble();
        double duration2Double = duration2.toDouble();
        double duration12Total = (duration1 + duration2).toDouble();
        expect(result.dayTotals.length, equals(28));
        expect(result.dayTotals[0], equals(duration1Double));
        expect(result.dayTotals[2], equals(duration2Double));
        expect(result.dayTotals[1], equals(duration12Total));
        expect(result.dayTotals[18], equals(0.0));
      });

      test('correctly for non-Sunday', () {
        DurationGraphData result = WeekData.generateDurationGraphData(
            fiveWeeks, DateTime.tuesday, GraphDateType.last28Days);
        expect(result.dayTotals.length, equals(28));
        expect(result.dayTotals[0], equals(duration2double));
        expect(result.dayTotals[3], equals(duration1double));
        expect(result.dayTotals[23], equals(duration12total));
        expect(result.dayTotals[14], equals(0.0));
      });

      test('raises exception if data length is not 4 for a Sunday', () {
        expect(() {
          WeekData.generateRatingsGraphData(
              fiveWeeks, DateTime.sunday, GraphDateType.last28Days);
        }, throwsArgumentError);
      });

      test('raises exception if data length is not 5 for a non-Sunday', () {
        expect(() {
          WeekData.generateRatingsGraphData(
              fourWeeks, DateTime.monday, GraphDateType.last28Days);
        }, throwsArgumentError);
      });
    });
  });

  // group('Generates StatsTilesGrid', () {
  //   test('Correctly for a sunday', () {
  //     StatsTilesGrid result =
  //         WeekData.generateLast7DaysStatsTilesGrid(twoWeeks, DateTime.sunday);
  //     expect(result.nSessions, equals('10'));
  //     expect(result.focus, equals(focus12average.toStringAsFixed(1)));
  //     expect(result.progress,
  //         equals(((progress1 + progress2) / 2).toStringAsFixed(1)));
  //     expect(result.satisfaction, equals((satisfaction2).toStringAsFixed(1)));
  //     expect(result.averageDuration,
  //         equals(((duration1 + duration2) / 2).toStringAsFixed(1)));
  //   });

  //   test('Correctly for a non-sunday (wed)', () {
  //     StatsTilesGrid result = WeekData.generateLast7DaysStatsTilesGrid(
  //         twoWeeks, DateTime.wednesday);
  //     // Should be Thu - Sun from week 1 and Mon - Wed from Week 2
  //     expect(result.nSessions, equals('10'));
  //     expect(result.focus, equals(focus12average.toStringAsFixed(1)));
  //     expect(result.progress,
  //         equals(((progress1 + progress2) / 2).toStringAsFixed(1)));
  //     expect(result.satisfaction, equals((satisfaction2).toStringAsFixed(1)));
  //     expect(result.averageDuration,
  //         equals(((duration1 + duration2) / 2).toStringAsFixed(1)));
  //   });

  //   test('Correctly for a non-sunday (mon)', () {
  //     StatsTilesGrid result =
  //         WeekData.generateLast7DaysStatsTilesGrid(twoWeeks, DateTime.monday);
  //     expect(result.nSessions, equals('11'));
  //     expect(result.focus,
  //         equals(((5 * focus1 + 6 * focus2) / 11).toStringAsFixed(1)));
  //     expect(result.progress,
  //         equals(((5 * progress1 + 6 * progress2) / 11).toStringAsFixed(1)));
  //     expect(result.satisfaction, equals((satisfaction2).toStringAsFixed(1)));
  //     expect(result.averageDuration,
  //         equals(((5 * duration1 + 6 * duration2) / 11).toStringAsFixed(1)));
  //   });
  // });
}
