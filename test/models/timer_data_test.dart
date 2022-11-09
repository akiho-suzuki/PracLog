import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/models/timer_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late TimerData timerData;
  final DateTime dummyDateTime1 =
      DateTime.utc(2022, 12, 01, 12, 10, 13); // 2022-12-01 12:10:13
  final DateTime dummyDateTime2 =
      DateTime.utc(2022, 12, 01, 12, 11, 23); // 2022-12-01 12:11:23

  setUp(() {
    timerData = TimerData.empty();
  });
  group('Basic timer functions:', () {
    test('Time is added correctly on start', () {
      timerData.startTimer(dummyDateTime1);
      var result = timerData.data;
      expect(
          result,
          equals([
            [dummyDateTime1, null]
          ]));
    });

    test('Time is added correctly on end', () {
      timerData.startTimer(dummyDateTime1);
      timerData.stopTimer(dummyDateTime2);
      var result = timerData.data;
      expect(
          result,
          equals([
            [dummyDateTime1, dummyDateTime2]
          ]));
    });

    test('Data is cleared', () {
      timerData.startTimer(dummyDateTime1);
      timerData.stopTimer(dummyDateTime2);
      timerData.clear();
      var result = timerData.data;
      expect(result, equals([]));
    });

    test('Correctly returns timerStatus when it is on', () {
      timerData.startTimer(dummyDateTime1);
      expect(timerData.timerOn(), equals(true));
    });

    test('Correctly returns timerStatus when it is off', () {
      timerData.startTimer(dummyDateTime1);
      timerData.stopTimer(dummyDateTime2);
      expect(timerData.timerOn(), equals(false));
    });

    test('Correctly returns timerStatus when it is empty', () {
      expect(timerData.timerOn(), equals(false));
    });

    test('Correctly returns curent timer value', () {
      timerData.startTimer(dummyDateTime1);
      timerData.stopTimer(dummyDateTime2);
      expect(timerData.currentTimerValue(), equals(70));
    });
  });
  group('Saves data', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });
    test('correctly when timer is stopped', () async {
      timerData.startTimer(dummyDateTime1);
      timerData.stopTimer(dummyDateTime2);
      await timerData.saveData();

      TimerData result = TimerData.empty();
      await result.fetchData();
      expect(
          result.data,
          equals([
            [dummyDateTime1, dummyDateTime2]
          ]));
    });
    test('correctly when timer is ongoing', () async {
      timerData.startTimer(dummyDateTime1);
      await timerData.saveData();

      TimerData result = TimerData.empty();
      await result.fetchData();
      expect(
          result.data,
          equals([
            [dummyDateTime1, null]
          ]));
    });

    test('correctly if timer has not started yet', () async {
      await timerData.saveData();
      TimerData result = TimerData.empty();
      await result.fetchData();
      expect(result.data, equals([]));
    });
  });
}
