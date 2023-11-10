import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/ui/pieces/widgets/piece_list.dart';

class PieceScreen extends StatelessWidget {
  final Isar isar;
  const PieceScreen({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return PieceList(
      isar: isar,
      showCurrent: true,
    );
  }
}
