import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/practice_goal.dart';
import '../test_data.dart';

void main() {
  group(
    'Practice goals methods: ',
    () {
      Log testLogWithOneGoal = Log(
          date: DateTime.utc(2022, 02, 03),
          pieceId: testPieceId,
          title: testPieceTitle,
          composer: testPieceComposer,
          durationInMin: 45,
          goalsList: [testGoal1]);

      Log testLogWithMultipleGoals = Log(
          date: DateTime.utc(2022, 02, 03),
          pieceId: testPieceId,
          title: testPieceTitle,
          composer: testPieceComposer,
          durationInMin: 45,
          goalsList: [testGoal1, testTickedGoal]);

      Log testLogWithNoGoal = Log(
        date: DateTime.utc(2022, 02, 03),
        pieceId: testPieceId,
        title: testPieceTitle,
        composer: testPieceComposer,
        durationInMin: 45,
      );

      Log testLogWithEmptyGoals = Log(
        date: DateTime.utc(2022, 02, 03),
        pieceId: testPieceId,
        title: testPieceTitle,
        composer: testPieceComposer,
        durationInMin: 45,
        goalsList: [],
      );

      group('Practice goals are converted to a map', () {
        test('for a single goal', () {
          Map<String, bool>? result = testLogWithOneGoal.goalsAsMap;
          expect(result, equals({testGoal1Text: false}));
        });

        test('for multiple goals', () {
          Map<String, bool> expected = {
            testGoal1Text: false,
            testGoal2Text: true,
          };
          Map<String, bool>? result = testLogWithMultipleGoals.goalsAsMap;
          expect(result, equals(expected));
        });

        test('returns null if goal list is null', () {
          Map<String, bool>? result = testLogWithNoGoal.goalsAsMap;
          expect(result, equals(null));
        });

        test('returns null if goal list is empty', () {
          Map<String, bool>? result = testLogWithEmptyGoals.goalsAsMap;
          expect(result, equals(null));
        });
      });

      group('Goal maps from Firestore converted to Practice Goal list', () {
        test('for single goal', () {
          Map<String, dynamic> firestoreMap = {testGoal1Text: false};
          List<PracticeGoal>? result =
              Log.getGoalsListFromFirestoreMap(firestoreMap);
          List<PracticeGoal>? expected = [testGoal1];
          expect(result![0].text, equals(expected[0].text));
        });

        test('for multiple goals', () {
          Map<String, dynamic> firestoreMap = {
            testGoal1Text: false,
            testGoal2Text: true
          };
          List<PracticeGoal>? result =
              Log.getGoalsListFromFirestoreMap(firestoreMap);
          List<PracticeGoal>? expected = [testGoal1, testGoal2];
          expect(result![0].text, equals(expected[0].text));
          expect(result[1].text, equals(expected[1].text));
        });
      });
    },
  );

  group('Converts logs into a data list for CSV export', () {
    test('correctly', () {
      DateTime date1 = DateTime.utc(2022, 06, 01);
      DateTime date2 = DateTime.utc(2022, 06, 01);
      Log log1 = generateLog1(date1);
      Log log2 = generateLog2(date2);
      List<Log> logs = [log1, log2];
      Map<String, List<List>> result = Log.convertToDatalistList(logs);

      List<List> expectedLogsData = [
        // Log 1
        [
          log1.id,
          date1,
          testPieceId,
          testPieceComposer,
          testPieceTitle,
          null,
          null,
          duration1,
          null,
          progress1,
          focus1,
          null
        ],
        // Log 2
        [
          log2.id,
          date2,
          testPieceId,
          testPieceComposer,
          testPieceTitle,
          null,
          null,
          duration2,
          satisfaction2,
          progress2,
          focus2,
          null
        ],
      ];
      expect(result[Log.logsData]!, expectedLogsData);
      expect(result[Log.goalsData]!, equals([]));
    });

    test('correctly for logs with goals', () {
      List<Log> logs = [
        generateLog1With2Goals(testDate),
        generateLog2(testDate)
      ];
      Map<String, List<List>> result = Log.convertToDatalistList(logs);
      List<List> expectedGoalsData = [
        [null, testGoal1Text, false],
        [null, testGoal2Text, true],
      ];

      List<List> expectedLogsData = [
        [
          null,
          testDate,
          testPieceId,
          testPieceComposer,
          testPieceTitle,
          null,
          null,
          duration1,
          null,
          progress1,
          focus1,
          null
        ],
        [
          null,
          testDate,
          testPieceId,
          testPieceComposer,
          testPieceTitle,
          null,
          null,
          duration2,
          satisfaction2,
          progress2,
          focus2,
          null
        ]
      ];
      expect(result[Log.goalsData]!, equals(expectedGoalsData));
      expect(result[Log.logsData]!, equals(expectedLogsData));
    });
  });
}
