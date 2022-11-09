import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/services/database/week_data_database.dart';
import '../../test_data.dart';

void main() {
  late CollectionReference fakeWeekDataCollection;
  late WeekDataDatabase weekDataDatabase;

  Map<String, int> emptyNSessionMap = {
    'mon': 0,
    'tue': 0,
    'wed': 0,
    'thu': 0,
    'fri': 0,
    'sat': 0,
    'sun': 0,
  };

  setUp(() {
    fakeWeekDataCollection = FakeFirebaseFirestore().collection(Label.weekData);
    weekDataDatabase =
        WeekDataDatabase(weekDataCollection: fakeWeekDataCollection);
  });

  group('Updates correctly', () {
    test('when log is added', () async {
      Log log = generateLog1(DateTime.utc(2022, 05, 24));
      await weekDataDatabase.addLog(log);
      QuerySnapshot snapshot = await fakeWeekDataCollection.get();
      QueryDocumentSnapshot result = snapshot.docs.first;
      expect(
          result[Label.nSessionsList],
          equals({
            'mon': 0,
            'tue': 1,
            'wed': 0,
            'thu': 0,
            'fri': 0,
            'sat': 0,
            'sun': 0,
          }));
      expect(result[Label.focusList]['tue'], equals([focus1]));
    });

    test('correctly when a log is edited', () async {
      // Add log
      Log oldLog = generateLog1(DateTime.utc(2022, 05, 24));
      await weekDataDatabase.addLog(oldLog);
      // Edit it
      Log newLog = generateLog2(DateTime.utc(2022, 05, 24));
      await weekDataDatabase.editLog(oldLog, newLog);
      // Check
      QuerySnapshot snapshot = await fakeWeekDataCollection.get();
      QueryDocumentSnapshot result = snapshot.docs.first;
      expect(result[Label.focusList]['tue'], equals([focus2]));
    });

    test('correctly when a log is deleted', () async {
      // Add log
      Log log = generateLog1(DateTime.utc(2022, 05, 24));
      await weekDataDatabase.addLog(log);
      // Delete it
      await weekDataDatabase.deleteLog(log);
      // Check
      QuerySnapshot snapshot = await fakeWeekDataCollection.get();
      QueryDocumentSnapshot result = snapshot.docs.first;
      expect(result[Label.focusList]['tue'], equals([]));
    });
  });

// TODO write tests
  group('Documents required for graph data', () {
    test('is returned correctly for 28 day data', () async {});
    test('is returned correctly for 28 day data for a Sunday', () async {});

    test('is returned correctly for 7 day data', () async {});

    test('is returned correctly for 7 day data for a Sunday', () async {});
  });

  group('Updates for multiple logs delete', () {
    test('correctly for deletes within a week', () async {
      List<Log> logList = [];
      // Add dummy logs for one week
      for (DateTime date in week1dates) {
        Log log = generateLog1(date);
        logList.add(log);
        await weekDataDatabase.addLog(log);
      }
      // Check that weekData has been correctly updated
      QuerySnapshot snapshot = await fakeWeekDataCollection.get();
      QueryDocumentSnapshot result = snapshot.docs.first;
      expect(
          result[Label.nSessionsList],
          equals({
            'mon': 1,
            'tue': 2,
            'wed': 1,
            'thu': 3,
            'fri': 1,
            'sat': 1,
            'sun': 1,
          }));
      // Delete all logs
      await weekDataDatabase.updateForMultipleLogDelete(logList);
      // Check
      snapshot = await fakeWeekDataCollection.get();
      result = snapshot.docs.first;
      expect(
          result[Label.nSessionsList],
          equals({
            'mon': 0,
            'tue': 0,
            'wed': 0,
            'thu': 0,
            'fri': 0,
            'sat': 0,
            'sun': 0,
          }));
    });

    test('correctly for deletes over multiple weeks', () async {
      List<Log> logList = [];
      // Add dummy logs for week 1
      for (DateTime date in week1dates) {
        Log log = generateLog1(date);
        logList.add(log);
        await weekDataDatabase.addLog(log);
      }
      // Add dummy logs for week 2
      for (DateTime date in week2dates) {
        Log log = generateLog1(date);
        logList.add(log);
        await weekDataDatabase.addLog(log);
      }

      // Delete all logs
      await weekDataDatabase.updateForMultipleLogDelete(logList);
      // Check
      QuerySnapshot snapshot = await fakeWeekDataCollection.get();
      QueryDocumentSnapshot week1 = snapshot.docs.first;
      QueryDocumentSnapshot week2 = snapshot.docs.last;
      expect(week1[Label.nSessionsList], equals(emptyNSessionMap));
      expect(week2[Label.nSessionsList], equals(emptyNSessionMap));
    });
  });
}
