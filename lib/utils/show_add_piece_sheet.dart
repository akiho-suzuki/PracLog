import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/ui/pieces/add_piece_sheet.dart';

void showAddPieceSheet(BuildContext context, Isar isar) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: AddPieceSheet(isar: isar),
    ),
  );
}
