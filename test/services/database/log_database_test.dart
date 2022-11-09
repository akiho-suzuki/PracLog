import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/services/database/log_database.dart';
import '../../test_data.dart';
import 'package:praclog/helpers/datetime_helpers.dart';

void main() {
  late CollectionReference fakeLogCollection;
  late LogDatabase logDatabase;

  setUp(() {
    fakeLogCollection = FakeFirebaseFirestore().collection(Label.logs);

    logDatabase = LogDatabase(logCollection: fakeLogCollection);
  });

  group('Adds log', () {
    late QuerySnapshot result;

    setUp(() {
      return Future(() async {
        result = await fakeLogCollection.get();
        expect(result.docs.length, 0);
      });
    });

    test('with no ratings', () async {
      await logDatabase.addLog(generateLogWithoutRatings(testDate));
      result = await fakeLogCollection.get();
      expect(result.docs.length, 1);
      expect(result.docs.first[Label.pieceId], equals(testPieceId));
      DateTime resultDate = result.docs.first[Label.date].toDate();
      expect(resultDate.getDateOnly(), equals(testDate.getDateOnly()));
    });

    test('with ratings', () async {
      await logDatabase.addLog(generateLog1(testDate));
      result = await fakeLogCollection.get();
      expect(result.docs.length, 1);
      expect(result.docs.first[Label.pieceId], equals(testPieceId));
      expect(result.docs.first[Label.focus], equals(focus1));
      expect(result.docs.first[Label.progress], equals(progress1));
      expect(result.docs.first[Label.satisfaction], equals(null));
    });

    test('with practice goals', () async {
      await logDatabase.addLog(generateLog1With2Goals(testDate));
      result = await fakeLogCollection.get();
      expect(result.docs.length, 1);
      expect(result.docs.first[Label.pieceId], equals(testPieceId));
      expect(result.docs.first[Label.goals], equals(testGoalMap));
    });
  });

  test('Deletes log', () async {
    // Add a log
    var log = await addTestLog(fakeLogCollection);
    var result = await fakeLogCollection.get();
    expect(result.docs.length, equals(1));

    // Delete
    await logDatabase.deleteLog(log);
    result = await fakeLogCollection.get();
    expect(result.docs.length, equals(0));
  });

  group('Edits log', () {
    late Log log;

    setUp(() {
      return Future(() async {
        // Add a log
        log = await addTestLog(fakeLogCollection);
      });
    });

    test('with ratings', () async {
      // Edit log
      const int newSatisfaction = 2;
      const int newDuration = 30;

      final Log newLog = Log(
        id: log.id,
        pieceId: testPieceId,
        title: testPieceTitle,
        composer: testPieceComposer,
        date: testDate,
        satisfaction: newSatisfaction,
        progress: progress1,
        focus: focus1,
        durationInMin: newDuration,
      );

      await logDatabase.editLog(newLog);

      // Check after edit
      var result = await fakeLogCollection.get();
      expect(result.docs.first[Label.durationInMin], equals(newDuration));
      expect(result.docs.first[Label.satisfaction], equals(newSatisfaction));
      expect(result.docs.first[Label.focus], equals(focus1));
    });

    test('with goals', () async {
      // Edit log
      const String newGoalText = 'A brand new goal!';
      final PracticeGoal newGoal = PracticeGoal(text: newGoalText);
      final List<PracticeGoal> newPracticeGoalList = [testGoal1, newGoal];

      final Log newLog = Log(
        id: log.id,
        pieceId: testPieceId,
        title: testPieceTitle,
        composer: testPieceComposer,
        date: testDate,
        durationInMin: duration1,
        focus: focus1,
        progress: progress1,
        satisfaction: null,
        goalsList: newPracticeGoalList,
      );

      await logDatabase.editLog(newLog);

      // Check after edit
      var result = await fakeLogCollection.get();
      expect(result.docs.first[Label.durationInMin], equals(duration1));
      expect(result.docs.first[Label.goals],
          equals({testGoal1Text: false, newGoalText: false}));
    });
  });

  group('Logs for a specific piece', () {
    test('are updated', () async {
      for (int i = 0; i < 10; i++) {
        await addTestLog(fakeLogCollection);
      }
      String newTitle = 'newTitle';
      String newComposer = 'newComposer';
      Piece newPiece =
          Piece(title: newTitle, composer: newComposer, id: testPieceId);
      await logDatabase.updatePieceInfo(newPiece);

      var result = await fakeLogCollection.get();
      expect(result.docs.length, equals(10));
      expect(result.docs.first[Label.title], equals(newTitle));
      expect(result.docs.first[Label.composer], equals(newComposer));
    });

    test('are updated for specific movements', () async {
      for (int i = 0; i < 10; i++) {
        await addTestLogWithMvt(fakeLogCollection);
      }
      String newMovement2 = 'New second movement';
      Piece newPiece = Piece(
          title: testPieceTitle,
          composer: testPieceComposer,
          id: testPieceId,
          movements: [testPieceMovement1, newMovement2]);
      await logDatabase.updatePieceInfo(newPiece);
      var result = await fakeLogCollection.get();
      expect(result.docs.length, equals(10));
      expect(result.docs.first[Label.movementTitle], equals(newMovement2));
    });

    test('are deleted', () async {
      for (int i = 0; i < 10; i++) {
        await addTestLog(fakeLogCollection);
      }
      var result = await fakeLogCollection.get();
      expect(result.docs.length, equals(10));
      await logDatabase.deleteLogsForPiece(testPiece);
      result = await fakeLogCollection.get();
      expect(result.docs.length, equals(0));
    }, skip: 'Throws and error "Unsupported", from Fake Firestore');
  });

  // test('Gets logs for a week', () async {
  //   DateTime date = DateTime.utc(2022, 05, 05, 10, 25);
  //   List<DateTime> rightWeek = [
  //     DateTime.utc(2022, 05, 02),
  //     DateTime.utc(2022, 05, 04),
  //     DateTime.utc(2022, 05, 05),
  //     DateTime.utc(2022, 05, 06),
  //     DateTime.utc(2022, 05, 08),
  //   ];
  //   List<DateTime> wrongWeek = [
  //     DateTime.utc(2022, 05, 01),
  //     DateTime.utc(2022, 05, 09),
  //     DateTime.utc(2021, 05, 05),
  //     DateTime.utc(2022, 04, 06),
  //     DateTime.utc(2022, 06, 08),
  //   ];

  //   Log generateLog(DateTime date) => Log(
  //         composer: testPieceComposer,
  //         title: testPieceTitle,
  //         date: date,
  //         durationInMin: 50,
  //         pieceId: testPieceId,
  //       );

  //   for (DateTime date in rightWeek) {
  //     await fakeLogCollection.add(generateLog(date).toJson());
  //   }
  //   for (DateTime date in wrongWeek) {
  //     await fakeLogCollection.add(generateLog(date).toJson());
  //   }

  //   var result = await fakeLogCollection.get();
  //   expect(result.docs.length, equals(10));

  //   List<Log> logs = await logDatabase.getLogsForWeek(date);
  //   expect(logs.length, equals(5));
  // });

  // group('Gets logs between two dates', () {
  //   late int logN;
  //   setUp(() async {
  //     List<DateTime> dates = week1dates + week2dates + week4dates + week5dates;
  //     logN = dates.length;
  //     for (int i = 0; i < dates.length; i++) {
  //       Log log = i.isEven ? generateLog1(dates[i]) : generateLog2(dates[i]);
  //       await logDatabase.addLog(log);
  //     }
  //   });

  //   test('correctly', () async {
  //     List<Log>? result = await logDatabase.getAllLogsBetween(
  //         DateTime.utc(2022, 05, 09), DateTime.utc(2022, 06, 12));
  //     expect(result!.length, equals(logN));
  //   });

  //   test('correctly for one day', () async {
  //     List<Log>? result = await logDatabase.getAllLogsBetween(
  //         DateTime.utc(2022, 06, 12), DateTime.utc(2022, 06, 12));
  //     expect(result!.length, equals(2));
  //   });

  //   test('correctly for a period without logs', () async {
  //     List<Log>? result = await logDatabase.getAllLogsBetween(
  //         DateTime.utc(2022, 05, 23), DateTime.utc(2022, 05, 29));
  //     expect(result!.length, equals(0));
  //   });

  //   test('throws error if to date is before from date', () async {
  //     expect(() async {
  //       await logDatabase.getAllLogsBetween(
  //           DateTime.utc(2022, 05, 19), DateTime.utc(2022, 05, 13));
  //     }, throwsArgumentError);
  //   });
  // });
}
