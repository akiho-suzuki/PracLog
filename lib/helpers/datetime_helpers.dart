import 'package:intl/intl.dart';

extension MyDateTimeHelpers on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int numberOfDaysBetween(DateTime other) {
    DateTime from = DateTime(year, month, day);
    DateTime to = DateTime(other.year, other.month, other.day);
    return (to.difference(from).inHours / 24).round();
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Returns the most recent Monday
  DateTime getWeekStart() {
    return DateTime(year, month, day - (weekday - 1));
  }

  /// Returns end of the week (Sunday)
  DateTime getThisSun() {
    return DateTime(year, month, day - (weekday - 7));
  }

  /// Returns the DateTime as a String in form (Jul 31, 2022)
  String getWrittenDate() {
    return DateFormat.yMMMd().format(this);
  }

  /// Returns the DateTime as a String with just year, month, day (no time)
  String getDateOnly() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  DateTime setAtStartOfDay() {
    return copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  DateTime setAtEndOfDay() {
    return copyWith(
        hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
  }

  String getMonthYear() {
    return DateFormat.yMMMM().format(this).toUpperCase();
  }

  DateTime getNWeekBefore(int n) {
    return subtract(Duration(days: 7 * n));
  }

  DateTime getNWeekAfter(int n) {
    return add(Duration(days: 7 * n));
  }

  String getDateMonth() {
    return DateFormat.MMMMd().format(this);
  }

  /// Returns appropraite text for the date separators in the log list on `LogScreen`
  String getDateCategory() {
    final DateTime today = DateTime.now().setAtEndOfDay();
    final DateTime yesterday =
        DateTime.now().subtract(const Duration(days: 1)).setAtStartOfDay();
    final DateTime startOfWeek = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - 1))
        .setAtStartOfDay();
    final DateTime startOfLastWeek = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday + 6))
        .setAtStartOfDay();
    final DateTime startofThisMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1)
            .setAtStartOfDay();

    if (isSameDate(today)) {
      return 'TODAY';
    } else if (isSameDate(yesterday)) {
      return 'YESTERDAY';
    } else if (isBefore(yesterday) && isAfter(startOfWeek)) {
      return 'EARLIER THIS WEEK';
    } else if (isBefore(startOfWeek) && isAfter(startOfLastWeek)) {
      return 'LAST WEEK';
    } else if (isBefore(startOfLastWeek) && isAfter(startofThisMonth)) {
      return 'EARLIER THIS MONTH';
    } else {
      return getMonthYear();
    }
  }
}
