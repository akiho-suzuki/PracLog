import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';

part 'piece.g.dart';

@Collection()
class Piece {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  late String title;

  @Index(caseSensitive: false)
  late String composer;

  List<String>? movements;

  @Index()
  late bool isCurrent;

  @Backlink(to: 'piece')
  final logs = IsarLinks<Log>();

  @override
  String toString() {
    return "$composer: $title";
  }
}
