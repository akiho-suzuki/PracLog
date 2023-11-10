import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/ui/pieces/widgets/piece_list.dart';

class PastPiecesScreen extends StatelessWidget {
  final Isar isar;
  const PastPiecesScreen({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past pieces'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: PieceList(isar: isar, showCurrent: false),
      ),
    );
  }
}
