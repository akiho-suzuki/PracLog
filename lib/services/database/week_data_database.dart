import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:praclog/custom_error.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/week_data.dart';
import '../../helpers/datetime_helpers.dart';
import 'package:rxdart/rxdart.dart';

class WeekDataDatabase {
  final CollectionReference weekDataCollection;

  WeekDataDatabase({required this.weekDataCollection});

  CollectionReference get convertedWeekDataCollection =>
      weekDataCollection.withConverter<WeekData>(
          fromFirestore: (snapshot, _) =>
              WeekData.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (weekData, _) => weekData.toJson());

  // Updates the `WeekData` with `newData` on Firestore. Throws an error if the `newData` does not have an ID.
  Future _update(WeekData newData) async {
    try {
      if (newData.id == null) {
        throw CustomError('WeekData must have an ID to be updated');
      }
      await convertedWeekDataCollection.doc(newData.id).set(newData);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Updates the weekData for an added log
  Future addLog(Log log) async {
    WeekData weekData = await _getWeekData(log.date);
    weekData.update(log);
    _update(weekData);
  }

  /// Updates the weekData for an edited log
  Future editLog(Log oldLog, Log newLog) async {
    WeekData weekData = await _getWeekData(oldLog.date);
    weekData.update(oldLog, reverseUpdate: true);
    weekData.update(newLog);
    _update(weekData);
  }

  /// Updates the weekData for a deleted log
  Future deleteLog(Log log) async {
    WeekData weekData = await _getWeekData(log.date);
    weekData.update(log, reverseUpdate: true);
    _update(weekData);
  }

  /// Returns `WeekData` for the week of the `date`. If the relevant data does not exist, it will create a new document on Firestore and return an empty ```WeekData```. Will throw an error if more than one document is found on Firestore for the date, as this should never happen.
  Future<WeekData> _getWeekData(DateTime date,
      {bool createIfNoneExists = true}) async {
    // Get the weekStartDate as String, which is Firestore will be searched
    String weekStartDate = date.getWeekStart().getDateOnly();

    // Get the relevant WeekData doc for that week
    QuerySnapshot snapshot = await weekDataCollection
        .where(Label.weekStartDate, isEqualTo: weekStartDate)
        .get();

    // If no document is found, create a new empty WeekData.
    if (snapshot.docs.isEmpty) {
      WeekData newData =
          WeekData.emptyStats(weekStartDate: date.getWeekStart());
      //  Save it to Firestore if createIfNoneExists is true
      if (createIfNoneExists) {
        DocumentReference newDoc =
            await convertedWeekDataCollection.add(newData);
        return WeekData.emptyStats(
            weekStartDate: date.getWeekStart(), id: newDoc.id);
      } else {
        return newData;
      }

      // Throw Error if more than one doc is found (this should never happen)
    } else if (snapshot.docs.length > 1) {
      throw CustomError(
          'More than one document found in WeekData collection for the date $weekStartDate');

      // Otherwise return the fetched document
    } else {
      QueryDocumentSnapshot doc = snapshot.docs.first;
      return WeekData.fromJson(doc.id, doc.data() as Map<String, Object?>);
    }
  }

  /// Get document necessary for last 7 days of data from a certain date
  Future<List<WeekData>> last7DaysData(DateTime fromDate) async {
    DateTime thisWeek = fromDate.getWeekStart();
    List<WeekData> result = [];
    WeekData data = await _getWeekData(fromDate, createIfNoneExists: false);
    result.add(data);
    // If fromDate is a sunday, only need data from that week. Otherwise, add previous week's data as well
    if (fromDate.weekday != DateTime.sunday) {
      DateTime date = thisWeek.getNWeekBefore(1);
      WeekData? previousWeek =
          await _getWeekData(date, createIfNoneExists: false);
      result.insert(0, previousWeek);
    }
    return result;
  }

  /// Get documents necessary for last 28 days of data from a certain date
  Future<List<WeekData>> last28DaysData(DateTime fromDate) async {
    DateTime thisWeek = fromDate.getWeekStart();
    List<WeekData> list = [];
    // If current date is sunday, only need 4 weeks (docs). Otherwise, need five weeks (docs)
    int i = fromDate.weekday == DateTime.sunday ? 3 : 4;
    for (i; i > -1; i--) {
      DateTime date = thisWeek.getNWeekBefore(i);
      WeekData weekData = await _getWeekData(date, createIfNoneExists: false);
      list.add(weekData);
    }
    return list;
  }

  /// Update weekData when deleting multiple logs
  Future updateForMultipleLogDelete(List<Log> logs) async {
    // Save updated weekData so that if multiple logs are from the same week, they can be written to Firestore in one go.
    Map<String, WeekData> weekDataMap = {};
    for (Log log in logs) {
      if (weekDataMap.containsKey(log.weekStartDate)) {
        weekDataMap[log.weekStartDate]!.update(log, reverseUpdate: true);
      } else {
        WeekData weekData = await _getWeekData(log.date);
        weekDataMap[log.weekStartDate] = weekData;
        weekData.update(log, reverseUpdate: true);
      }
    }
    // Send all the updated weekData to Firestore
    weekDataMap.forEach((_, weekData) async {
      await _update(weekData);
    });
  }

  /// Returns a stream of `WeekData` for the current week for the `date`
  Stream<WeekData> _thisWeekStream(DateTime date) async* {
    WeekData weekData = await _getWeekData(date);
    yield* weekDataCollection.doc(weekData.id).snapshots().map((snapshot) =>
        WeekData.fromJson(
            snapshot.id, snapshot.data() as Map<String, Object?>));
  }

  // Returns a list of 2 `WeekData` objects. One for last week, and one for current week (in that order)
  Stream<List<WeekData>> last7DaysStream(DateTime date) async* {
    Stream<WeekData> lastWeek = _thisWeekStream(date.getNWeekBefore(1));
    Stream<WeekData> thisWeek = _thisWeekStream(date);
    yield* Rx.combineLatest2<WeekData, WeekData, List<WeekData>>(
      lastWeek,
      thisWeek,
      (lastWeek, thisWeek) => [lastWeek, thisWeek],
    );
  }
}
