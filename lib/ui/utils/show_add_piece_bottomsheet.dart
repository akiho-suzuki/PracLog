import 'package:flutter/material.dart';
import 'package:praclog/ui/repertoire/widgets/add_piece_bottom_sheet.dart';

void showAddPieceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: const AddPieceBottomSheet(),
    ),
  );
}
