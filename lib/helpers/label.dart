/// A class with static strings to ensure no typos with doc and collection references
/// in Firestore and shared_preferences
class Label {
  // For MidPracticeData
  static String piece = 'piece';
  static String timerData = 'timerData';

  // Collection names
  static String users = 'users';
  static String repertoire = 'repertoire';
  static String logs = 'logs';
  static String pieceStats = 'pieceStats';

  // For pieces
  static String composer = 'composer';
  static String title = 'title';
  static String movements = 'movements';
  static String isCurrent = 'isCurrent';
  static String logId = 'logId';

  // For logs
  static String pieceId = 'pieceId';
  static String movementIndex = 'movementIndex';
  static String movementTitle = 'movementTitle';
  static String durationInMin = 'durationInMin';
  static String date = 'date';
  static String goals = 'goals';
  static String focus = 'focus';
  static String progress = 'progress';
  static String satisfaction = 'satisfaction';
  static String notes = 'notes';

  // For piece stats
  static String pieceStatsType = 'pieceStatsType';
  static String nSessions = 'nSessions';
  static String startDate = 'startDate';
  static String totalDurationInMin = 'totalDurationInMin';
  static String averageDuration = 'averageDuration';
  static String averageFocus = 'averageFocus';
  static String averageProgress = 'averageProgress';
  static String averageSatisfaction = 'averageSatisfaction';
  static String data = 'data';

//  For weekly summary stats
  static String weekData = 'weekData';
  static String weekStartDate = 'weekStartDate';
  static String nSessionsList = 'nSessionsList';
  static String focusList = 'focusList';
  static String progressList = 'progressList';
  static String satisfactionList = 'satisfactionList';
  static String durationsList = 'durationsList';
}
