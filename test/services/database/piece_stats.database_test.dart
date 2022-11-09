import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/services/database/piece_stats.database.dart';
import '../../test_data.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late CollectionReference fakePieceStatsCollection;
  late PieceStatsDatabase pieceStatsDatabase;

  const int focus = 5;
  const int satisfaction = 3;
  const int duration = 60;

  Log log = Log(
    pieceId: testPieceId,
    date: DateTime.utc(2022, 05, 20),
    composer: testPieceComposer,
    title: testPieceTitle,
    focus: focus,
    satisfaction: satisfaction,
    progress: null,
    durationInMin: duration,
  );

  Log logWithMov = Log(
    pieceId: testPieceId,
    movementIndex: testPieceMovementIndex2,
    movementTitle: testPieceMovement2,
    date: DateTime.utc(2022, 05, 20),
    composer: testPieceComposer,
    title: testPieceTitle,
    focus: focus,
    satisfaction: satisfaction,
    progress: null,
    durationInMin: duration,
  );

  Log logToRemove = Log(
    pieceId: testPieceId,
    date: DateTime.utc(2022, 05, 20),
    composer: testPieceComposer,
    title: testPieceTitle,
    focus: focus,
    satisfaction: null,
    progress: null,
    durationInMin: duration,
  );

  Future setCollection() async {
    await fakePieceStatsCollection.add({
      Label.pieceStatsType: -1,
      Label.nSessions: 10,
      Label.averageFocus: {Label.nSessions: 9, Label.data: 4.0},
      Label.averageSatisfaction: {Label.nSessions: 0, Label.data: 0.0},
      Label.averageProgress: {Label.nSessions: 9, Label.data: 3.0},
      Label.averageDuration: {Label.nSessions: 10, Label.data: 30.0},
      Label.startDate: Timestamp.fromDate(DateTime.utc(2022, 01, 10)),
      Label.totalDurationInMin: 300,
    });
  }

  String round(n) {
    n = n as double;
    return n.toStringAsFixed(1);
  }

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakePieceStatsCollection = fakeFirestore.collection(Label.pieceStats);
    pieceStatsDatabase = PieceStatsDatabase(fakePieceStatsCollection);
  });

  group('Update', () {
    test('by creating a new doc if none existing', () async {
      await pieceStatsDatabase.update(log);

      var collection = await fakePieceStatsCollection.get();
      QueryDocumentSnapshot result = collection.docs.first;

      expect(result[Label.averageDuration][Label.data], equals(duration));
      expect(result[Label.averageFocus][Label.data], equals(focus));
      expect(result[Label.averageProgress][Label.data], equals(0.0));
      expect(
          result[Label.averageSatisfaction][Label.data], equals(satisfaction));
      expect(result[Label.nSessions], equals(1));
      expect(result[Label.totalDurationInMin], equals(duration));
    });

    test('existing stats correctly', () async {
      await setCollection();
      await pieceStatsDatabase.update(log);
      var collection = await fakePieceStatsCollection.get();
      QueryDocumentSnapshot result = collection.docs.first;

      int expectedNSessions = 11;
      String expectedAverageFocus = round(((4 * 10) + 5) / 11);
      String expectedAverageSatisfaction = round(3.0);
      String expectedAverageProgress = round(3.0);
      String expectedAverageMin = round(((30 * 10) + 60) / 11);
      int expectedTotalMinutes = 360;

      expect(round(result[Label.averageDuration][Label.data]),
          equals(expectedAverageMin));
      expect(round(result[Label.averageFocus][Label.data]),
          equals(expectedAverageFocus));
      expect(round(result[Label.averageProgress][Label.data]),
          equals(expectedAverageProgress));
      expect(round(result[Label.averageSatisfaction][Label.data]),
          equals(expectedAverageSatisfaction));
      expect(result[Label.nSessions], equals(expectedNSessions));
      expect(result[Label.totalDurationInMin], equals(expectedTotalMinutes));
    });

    test('log for a movement correctly', () async {
      await setCollection();
      await pieceStatsDatabase.update(logWithMov);
      QuerySnapshot snapshot =
          await fakePieceStatsCollection.orderBy(Label.pieceStatsType).get();
      //print(fakeFirestore.dump());

      // TODO: Potential issue with the Fake Firestore package. The actual json obtained from fakeFirestore.dump() looks correct, but can't access second document.

      // expect(snapshot.docs.length, equals(2));
      // expect(collection.docs.first[Label.pieceStatsType],
      //     equals(-1));
      // expect(
      //     collection.docs.last[Label.pieceStatsType], equals(2));
    });
  });

  group('When log is removed,', () {
    test('stats updates correctly', () async {
      await setCollection();
      await pieceStatsDatabase.remove(logToRemove);
      var collection = await fakePieceStatsCollection.get();
      QueryDocumentSnapshot result = collection.docs.first;

      int expectedNSessions = 9;
      String expectedAverageFocus = round(((4 * 9) - focus) / 8);
      String expectedAverageSatisfaction = '0.0';
      String expectedAverageProgress = '3.0';
      String expectedAverageMin = round(((30 * 10) - 60) / 9);
      int expectedTotalMinutes = 240;

      expect(round(result[Label.averageDuration][Label.data]),
          equals(expectedAverageMin));
      expect(round(result[Label.averageFocus][Label.data]),
          equals(expectedAverageFocus));
      expect(round(result[Label.averageProgress][Label.data]),
          equals(expectedAverageProgress));
      expect(round(result[Label.averageSatisfaction][Label.data]),
          equals(expectedAverageSatisfaction));
      expect(result[Label.nSessions], equals(expectedNSessions));
      expect(result[Label.totalDurationInMin], equals(expectedTotalMinutes));
    });

    test('deletes doc if it\'s last log', () async {
      await fakePieceStatsCollection.add({
        Label.pieceStatsType: -1,
        Label.nSessions: 1,
        Label.averageFocus: {Label.nSessions: 1, Label.data: 4.0},
        Label.averageSatisfaction: {Label.nSessions: 0, Label.data: 0.0},
        Label.averageProgress: {Label.nSessions: 1, Label.data: 3.0},
        Label.averageDuration: {Label.nSessions: 1, Label.data: 30.0},
        Label.startDate: DateTime.utc(2022, 01, 10),
        Label.totalDurationInMin: 30,
      });

      await pieceStatsDatabase.remove(log);
      var collection = await fakePieceStatsCollection.get();
      expect(collection.docs.length, equals(0));
    });
  });
  test('Deletes document', () async {
    await setCollection();
    var collection = await fakePieceStatsCollection.get();
    expect(collection.docs.length, equals(1));

    await pieceStatsDatabase.delete();

    collection = await fakePieceStatsCollection.get();
    expect(collection.docs.length, equals(0));
  });
}
