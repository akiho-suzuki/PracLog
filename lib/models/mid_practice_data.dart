import 'package:praclog/helpers/label.dart';
import 'package:praclog/helpers/shared_pref_refs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MidPracticeData {
  final String pieceTitle;
  final String pieceId;
  final String pieceComposer;
  final int? movementIndex;
  final String? movementTitle;

  MidPracticeData(
      {required this.pieceTitle,
      required this.pieceComposer,
      required this.pieceId,
      this.movementIndex,
      this.movementTitle})
      // If movementIndex is not null, movementTitle must be supplied
      : assert(movementIndex != null ? movementTitle != null : true);

  /// Returns value of `isMidPractice`
  static isMidPractice(SharedPreferences sharedPreferences) =>
      sharedPreferences.getBool(SharedPrefRefs.inMidPractice) ?? false;

  static setMidPracticeToFalse() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setBool(SharedPrefRefs.inMidPractice, false);
  }

  static MidPracticeData fetchMidPracticeData(
      SharedPreferences sharedPreferences) {
    return MidPracticeData(
        pieceTitle: sharedPreferences.getString(Label.title)!,
        pieceComposer: sharedPreferences.getString(Label.composer)!,
        pieceId: sharedPreferences.getString(Label.pieceId)!,
        movementIndex: sharedPreferences.getInt(Label.movementIndex),
        movementTitle: sharedPreferences.getString(Label.movementTitle));
  }

  Future startPractice() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setBool(SharedPrefRefs.inMidPractice, true);
    await sharedPreferences.setString(Label.pieceId, pieceId);
    await sharedPreferences.setString(Label.title, pieceTitle);
    await sharedPreferences.setString(Label.composer, pieceComposer);
    if (movementIndex != null) {
      await sharedPreferences.setInt(Label.movementIndex, movementIndex!);
      await sharedPreferences.setString(Label.movementTitle, movementTitle!);
    }
  }
}
