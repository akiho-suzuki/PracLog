import 'package:praclog_v2/collections/log.dart';

Log generateLogWithRating(DateTime date, int? durationInMin, int? focus,
    int? satisfaction, int? progress) {
  return Log()
    ..dateTime = date
    ..durationInMin = durationInMin
    ..focus = focus
    ..satisfaction = satisfaction
    ..progress = progress;
}
