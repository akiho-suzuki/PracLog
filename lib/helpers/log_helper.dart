import 'package:praclog_v2/collections/log.dart';

class LogHelper {
  static String getPieceName(Log log) {
    if (log.piece.value != null) {
      return "${log.piece.value!.composer}: ${log.piece.value!.title}";
    } else {
      return "No piece info";
    }
  }
}
