import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/models/week_data.dart';

final DateTime testDate = DateTime.utc(2022, 07, 01);

// User
const String userId = 'userId123456';

// Test piece ------------------
const String testPieceId = '123abc';
const String testPieceTitle = 'Piece title No 1';
const String testPieceComposer = 'Some Composer';
const String testPieceMovement1 = '1st mvt';
const String testPieceMovement2 = '2nd mvt';
const List<String> testPieceMovementList = [
  testPieceMovement1,
  testPieceMovement2
];
const int testPieceMovementIndex1 = 1;
const int testPieceMovementIndex2 = 2;

final Piece testPiece =
    Piece(composer: testPieceComposer, title: testPieceTitle);

final Piece testPieceWithId =
    Piece(id: testPieceId, composer: testPieceComposer, title: testPieceTitle);

final Piece testPieceWithMovements = Piece(
    composer: testPieceComposer,
    title: testPieceTitle,
    movements: testPieceMovementList);

// Test practice goals ------------------
const String testGoal1Text = '1 An example goal';
final PracticeGoal testGoal1 = PracticeGoal(text: testGoal1Text);
const String testGoal2Text = '2 Another goal!!';
final PracticeGoal testGoal2 = PracticeGoal(text: testGoal2Text);
final PracticeGoal testTickedGoal =
    PracticeGoal(text: testGoal2Text, isTicked: true);

/// Map in form `{text: isTicked}` for testGoal1, testTickedGoal
final Map<String, dynamic> testGoalMap = {
  testGoal1Text: false,
  testGoal2Text: true
};

// Test logs ------------------

/// Contains duration1
Log generateLogWithoutRatings(DateTime date) {
  return Log(
    composer: testPieceComposer,
    pieceId: testPieceId,
    title: testPieceTitle,
    date: date,
    durationInMin: duration1,
  );
}

// Dummy log 1
int focus1 = 5;
int progress1 = 4;
int duration1 = 45;

/// Contains focus1, progress1, duration1
Log generateLog1(DateTime date) {
  return Log(
    composer: testPieceComposer,
    pieceId: testPieceId,
    title: testPieceTitle,
    date: date,
    focus: focus1,
    progress: progress1,
    durationInMin: duration1,
  );
}

/// Contains focus1, progress1, duration1, testGoal1
Log generateLog1With1Goal(DateTime date) {
  return Log(
    composer: testPieceComposer,
    pieceId: testPieceId,
    title: testPieceTitle,
    date: date,
    focus: focus1,
    progress: progress1,
    durationInMin: duration1,
    goalsList: [testGoal1],
  );
}

/// Contains focus1, progress1, duration1, testGoal1, tickedTestGoal
Log generateLog1With2Goals(DateTime date) {
  return Log(
    composer: testPieceComposer,
    pieceId: testPieceId,
    title: testPieceTitle,
    date: date,
    focus: focus1,
    progress: progress1,
    durationInMin: duration1,
    goalsList: [testGoal1, testTickedGoal],
  );
}

// Dummy log #2
int focus2 = 3;
int progress2 = 3;
int satisfaction2 = 2;
int duration2 = 30;

/// Contains focus2, progress1, satisfaction2, duration2
Log generateLog2(DateTime date) {
  return Log(
    composer: testPieceComposer,
    pieceId: testPieceId,
    title: testPieceTitle,
    date: date,
    focus: focus2,
    progress: progress2,
    satisfaction: satisfaction2,
    durationInMin: duration2,
  );
}

/// Adds a log with duration1, focus1, progress1, satisfaction2, testGoalMap
Future<Log> addTestLog(CollectionReference fakeLogCollection) async {
  var doc = await fakeLogCollection.add({
    Label.title: testPieceTitle,
    Label.composer: testPieceComposer,
    Label.date: testDate,
    Label.durationInMin: duration1,
    Label.pieceId: testPieceId,
    Label.focus: focus1,
    Label.progress: progress1,
    Label.satisfaction: satisfaction2,
    //Label.goals: testGoalMap,
  });

  return Log(
      id: doc.id,
      pieceId: testPieceId,
      title: testPieceTitle,
      composer: testPieceComposer,
      date: testDate,
      durationInMin: duration1,
      focus: focus1,
      progress: progress1,
      satisfaction: satisfaction2,
      goalsList: [testGoal1, testTickedGoal]);
}

/// Adds a log with duration1, focus1, progress1, satisfaction2, testGoalMap, with movement 2
Future<Log> addTestLogWithMvt(CollectionReference fakeLogCollection) async {
  var doc = await fakeLogCollection.add({
    Label.title: testPieceTitle,
    Label.composer: testPieceComposer,
    Label.date: testDate,
    Label.durationInMin: duration1,
    Label.pieceId: testPieceId,
    Label.focus: focus1,
    Label.progress: progress1,
    Label.satisfaction: satisfaction2,
    Label.goals: testGoalMap,
    Label.movementIndex: testPieceMovementIndex1,
    Label.movementTitle: testPieceMovement1,
  });

  return Log(
      id: doc.id,
      pieceId: testPieceId,
      title: testPieceTitle,
      movementIndex: testPieceMovementIndex1,
      movementTitle: testPieceMovement1,
      composer: testPieceComposer,
      date: testDate,
      durationInMin: duration1,
      focus: focus1,
      progress: progress1,
      satisfaction: satisfaction2,
      goalsList: [testGoal1, testTickedGoal]);
}

// *************** For WeekData tests ***************
final DateTime testWeekStartDate = DateTime.utc(2022, 05, 23);

// Expected aggregate data for dummy logs 1 & 2
double focus1double = focus1.toDouble();
double focus2double = focus2.toDouble();
double focus12average = (focus1 + focus2) / 2;
double duration1double = duration1.toDouble();
double duration2double = duration2.toDouble();
double duration12total = (duration1 + duration2).toDouble();

// Expected week data
List<double> expectedFocusListAverages = [
  focus12average,
  0.0,
  focus1double,
  0.0,
  focus12average,
  0.0,
  focus1double
];

Map<String, int> expectedNSessionsList = {
  'mon': 2,
  'tue': 0,
  'wed': 1,
  'thu': 0,
  'fri': 2,
  'sat': 0,
  'sun': 1,
};

List<double> expectedDurationTotals = [
  duration12total,
  0.0,
  duration1double,
  0.0,
  duration12total,
  0.0,
  duration1double
];

WeekData inputDummyWeekData(WeekData data) {
  Log monLog1 = generateLog1(DateTime.utc(2022, 05, 23));
  Log monLog2 = generateLog2(DateTime.utc(2022, 05, 23));
  Log wedLog1 = generateLog1(DateTime.utc(2022, 05, 25));
  Log friLog1 = generateLog1(DateTime.utc(2022, 05, 27));
  Log friLog2 = generateLog2(DateTime.utc(2022, 05, 27));
  Log sunLog1 = generateLog1(DateTime.utc(2022, 05, 29));
  data.update(monLog1);
  data.update(monLog2);
  data.update(wedLog1);
  data.update(friLog1);
  data.update(friLog2);
  data.update(sunLog1);
  return data;
}

void updateWithMultipleLogs(WeekData currentWeekData, List<DateTime> dates) {
  for (int i = 0; i < dates.length; i++) {
    Log log = i.isEven ? generateLog1(dates[i]) : generateLog2(dates[i]);
    currentWeekData.update(log);
  }
}

DateTime week1start = DateTime.utc(2022, 05, 09);
DateTime week2start = DateTime.utc(2022, 05, 16);
DateTime week3start = DateTime.utc(2022, 05, 23);
DateTime week4start = DateTime.utc(2022, 05, 30);
DateTime week5start = DateTime.utc(2022, 06, 06);
List<DateTime> weekStartDateList = [
  week1start,
  week2start,
  week3start,
  week4start,
  week5start
];

List<DateTime> week1dates = [
  DateTime.utc(2022, 05, 09),
  DateTime.utc(2022, 05, 10),
  DateTime.utc(2022, 05, 10),
  DateTime.utc(2022, 05, 11), // Wed    DateTime.utc(2022, 05, 12),
  DateTime.utc(2022, 05, 12), // Thu
  DateTime.utc(2022, 05, 12),
  DateTime.utc(2022, 05, 12),
  DateTime.utc(2022, 05, 13),
  DateTime.utc(2022, 05, 14),
  DateTime.utc(2022, 05, 15),
];

List<DateTime> week2dates = [
  DateTime.utc(2022, 05, 16), // Mon
  DateTime.utc(2022, 05, 16),
  DateTime.utc(2022, 05, 18), // Wed
  DateTime.utc(2022, 05, 18), // Wed
  DateTime.utc(2022, 05, 19),
  DateTime.utc(2022, 05, 20),
  DateTime.utc(2022, 05, 20),
  DateTime.utc(2022, 05, 21),
  DateTime.utc(2022, 05, 21),
  DateTime.utc(2022, 05, 22),
];

List<DateTime> week4dates = [
  DateTime.utc(2022, 05, 30),
  DateTime.utc(2022, 05, 31),
  DateTime.utc(2022, 06, 01),
  DateTime.utc(2022, 06, 01),
  DateTime.utc(2022, 06, 03),
  DateTime.utc(2022, 06, 03),
  DateTime.utc(2022, 06, 05),
];
List<DateTime> week5dates = [
  DateTime.utc(2022, 06, 06),
  DateTime.utc(2022, 06, 07), // Tues
  DateTime.utc(2022, 06, 08),
  DateTime.utc(2022, 06, 09),
  DateTime.utc(2022, 06, 10),
  DateTime.utc(2022, 06, 11),
  DateTime.utc(2022, 06, 11),
  DateTime.utc(2022, 06, 12),
  DateTime.utc(2022, 06, 12), // # 35 (odd)
];

List<WeekData> inputMonthDummyData() {
  // Week 1
  WeekData week1 = WeekData.emptyStats(weekStartDate: week1start);
  updateWithMultipleLogs(week1, week1dates);

// Week 2
  WeekData week2 = WeekData.emptyStats(weekStartDate: week2start);
  updateWithMultipleLogs(week2, week2dates);

  // Week 3 (empty)
  WeekData week3 = WeekData.emptyStats(weekStartDate: week3start);

  // Week 4
  WeekData week4 = WeekData.emptyStats(weekStartDate: week4start);
  updateWithMultipleLogs(week4, week4dates);

  // Week 5
  WeekData week5 = WeekData.emptyStats(weekStartDate: week5start);
  updateWithMultipleLogs(week5, week5dates);

  return [week1, week2, week3, week4, week5];
}
