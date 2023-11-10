import 'package:flutter_test/flutter_test.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/models/ratings_graph_data.dart';

import '../test_data.dart';

void main() {
  group("Generates graph data for a list of logs when", () {
    Log log1 = generateLogWithRating(DateTime.utc(2023, 05, 10), 60, 5, 5, 5);
    Log log2 = generateLogWithRating(DateTime.utc(2023, 05, 11), 60, 3, 3, 3);
    Log log2a = generateLogWithRating(DateTime.utc(2023, 05, 11), 30, 5, 3, 1);
    Log log2b = generateLogWithRating(DateTime.utc(2023, 05, 11), 15, 5, 5, 5);
    Log log3 = generateLogWithRating(DateTime.utc(2023, 05, 12), 60, 1, 3, 5);
    Log log3a = generateLogWithRating(DateTime.utc(2023, 05, 12), 60, 5, 5, 5);

    test("when the log list is empty", () {
      GraphData result = GraphData.getRatingsGraphData(
          [], DateTime.utc(2023, 05, 10), DateTime.utc(2023, 05, 12));
      expect(result.focusRatings, equals([0.0, 0.0, 0.0]));
      expect(result.satisfactionRatings, equals([0.0, 0.0, 0.0]));
      expect(result.progressRatings, equals([0.0, 0.0, 0.0]));
      expect(result.dayDurationData, equals([[], [], []]));
    });
    test("there is one per day", () {
      GraphData result = GraphData.getRatingsGraphData([log1, log2, log3],
          DateTime.utc(2023, 05, 10), DateTime.utc(2023, 05, 12));
      expect(result.focusRatings, equals([5.0, 3.0, 1.0]));
      expect(result.satisfactionRatings, equals([5.0, 3.0, 3.0]));
      expect(result.progressRatings, equals([5.0, 3.0, 5.0]));
      expect(
          result.dayDurationData,
          equals([
            [60],
            [60],
            [60]
          ]));
    });

    test("when there is some days with multiple logs", () {
      GraphData result = GraphData.getRatingsGraphData(
          [log1, log2, log2a, log3],
          DateTime.utc(2023, 05, 10),
          DateTime.utc(2023, 05, 12));
      expect(result.focusRatings, equals([5.0, 4.0, 1.0]));
      expect(result.satisfactionRatings, equals([5.0, 3.0, 3.0]));
      expect(result.progressRatings, equals([5.0, 2.0, 5.0]));
      expect(
          result.dayDurationData,
          equals([
            [60],
            [60, 30],
            [60]
          ]));
    });

    test("when there are some days with no log", () {
      GraphData result = GraphData.getRatingsGraphData(
          [log1, log3], DateTime.utc(2023, 05, 10), DateTime.utc(2023, 05, 12));
      expect(result.focusRatings, equals([5.0, 0.0, 1.0]));
      expect(result.satisfactionRatings, equals([5.0, 0.0, 3.0]));
      expect(result.progressRatings, equals([5.0, 0.0, 5.0]));
      expect(
          result.dayDurationData,
          equals([
            [60],
            [],
            [60]
          ]));
    });

    test("when there is no log on the first date", () {
      GraphData result = GraphData.getRatingsGraphData([log1, log2, log3],
          DateTime.utc(2023, 05, 09), DateTime.utc(2023, 05, 12));
      expect(result.focusRatings, equals([0.0, 5.0, 3.0, 1.0]));
      expect(result.satisfactionRatings, equals([0.0, 5.0, 3.0, 3.0]));
      expect(result.progressRatings, equals([0.0, 5.0, 3.0, 5.0]));
      expect(
          result.dayDurationData,
          equals([
            [],
            [60],
            [60],
            [60]
          ]));
    });

    test("when there is no log on the last date", () {
      GraphData result = GraphData.getRatingsGraphData([log1, log2, log3],
          DateTime.utc(2023, 05, 10), DateTime.utc(2023, 05, 13));
      expect(result.focusRatings, equals([5.0, 3.0, 1.0, 0.0]));
      expect(result.satisfactionRatings, equals([5.0, 3.0, 3.0, 0.0]));
      expect(result.progressRatings, equals([5.0, 3.0, 5.0, 0.0]));
      expect(
          result.dayDurationData,
          equals([
            [60],
            [60],
            [60],
            []
          ]));
    });

    test("when it is only for one day", () {
      GraphData result = GraphData.getRatingsGraphData(
          [log1], DateTime.utc(2023, 05, 10), DateTime.utc(2023, 05, 10));
      expect(result.focusRatings, equals([5.0]));
      expect(result.satisfactionRatings, equals([5.0]));
      expect(result.progressRatings, equals([5.0]));
      expect(
          result.dayDurationData,
          equals([
            [60]
          ]));
    });

    test("when it is multiple logs with multiple skipped days", () {
      GraphData result = GraphData.getRatingsGraphData([log2, log2a, log2b],
          DateTime.utc(2023, 05, 10), DateTime.utc(2023, 05, 15));
      expect(result.focusRatings,
          equals([0.0, (3 + 5 + 5) / 3, 0.0, 0.0, 0.0, 0.0]));
      expect(result.satisfactionRatings,
          equals([0.0, (3 + 3 + 5) / 3, 0.0, 0.0, 0.0, 0.0]));
      expect(result.progressRatings, equals([0.0, 3.0, 0.0, 0.0, 0.0, 0.0]));
      expect(
          result.dayDurationData,
          equals([
            [],
            [60, 30, 15],
            [],
            [],
            [],
            []
          ]));
    });

    test("when it is multiple logs on multiple consecutive days", () {
      GraphData result = GraphData.getRatingsGraphData(
          [log1, log2, log2a, log2b, log3, log3a],
          DateTime.utc(2023, 05, 10),
          DateTime.utc(2023, 05, 12));
      expect(result.focusRatings, equals([5.0, (3 + 5 + 5) / 3, 3.0]));
      expect(result.satisfactionRatings, equals([5.0, (3 + 3 + 5) / 3, 4.0]));
      expect(result.progressRatings, equals([5.0, 3.0, 5.0]));
      expect(
          result.dayDurationData,
          equals([
            [60],
            [60, 30, 15],
            [60, 60]
          ]));
    });

    group("there is missing ratings", () {
      Log log1missing =
          generateLogWithRating(DateTime.utc(2023, 05, 10), 0, 3, 3, null);

      Log log2missing =
          generateLogWithRating(DateTime.utc(2023, 05, 11), 0, 5, 5, null);

      Log log2AllMissing = generateLogWithRating(
          DateTime.utc(2023, 05, 11), 0, null, null, null);

      test("for one day, on one rating", () {
        GraphData result = GraphData.getRatingsGraphData([log1, log1missing],
            DateTime.utc(2023, 05, 10), DateTime.utc(2023, 05, 10));
        expect(result.focusRatings, equals([4.0]));
        expect(result.satisfactionRatings, equals([4.0]));
        expect(result.progressRatings, equals([5.0]));
        expect(
            result.dayDurationData,
            equals([
              [60, 0]
            ]));
      });

      test("for multiple days, on one rating", () {
        GraphData result = GraphData.getRatingsGraphData(
            [log1, log1missing, log2, log2missing],
            DateTime.utc(2023, 05, 10),
            DateTime.utc(2023, 05, 11));
        expect(result.focusRatings, equals([4.0, 4.0]));
        expect(result.satisfactionRatings, equals([4.0, 4.0]));
        expect(result.progressRatings, equals([5.0, 3.0]));
        expect(
            result.dayDurationData,
            equals([
              [60, 0],
              [60, 0]
            ]));
      });

      test("all missing for one rating", () {
        GraphData result = GraphData.getRatingsGraphData(
            [log1missing, log2missing],
            DateTime.utc(2023, 05, 10),
            DateTime.utc(2023, 05, 11));
        expect(result.focusRatings, equals([3.0, 5.0]));
        expect(result.satisfactionRatings, equals([3.0, 5.0]));
        expect(result.progressRatings, equals([0.0, 0.0]));
        expect(
            result.dayDurationData,
            equals([
              [0],
              [0]
            ]));
      });

      test("all missing for one log", () {
        GraphData result = GraphData.getRatingsGraphData(
            [log1missing, log2AllMissing],
            DateTime.utc(2023, 05, 10),
            DateTime.utc(2023, 05, 11));
        expect(result.focusRatings, equals([3.0, 0.0]));
        expect(result.satisfactionRatings, equals([3.0, 0.0]));
        expect(result.progressRatings, equals([0.0, 0.0]));
        expect(
            result.dayDurationData,
            equals([
              [0],
              [0]
            ]));
      });
    });
  });

  test("Throws error if startDate is after endDate", () {
    expect(() {
      GraphData.getRatingsGraphData(
          [], DateTime.utc(2023, 05, 13), DateTime.utc(2023, 05, 10));
    }, throwsArgumentError);
  });
}
