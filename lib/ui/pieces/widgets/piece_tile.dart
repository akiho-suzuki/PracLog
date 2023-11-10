import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/services/pieces_database.dart';
import 'package:praclog_v2/ui/pieces/edit_piece_screen.dart';
import 'package:praclog_v2/ui/pieces/piece_info_screen.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

// Piece Tile action options
enum PieceTileActions { delete, edit, toggleIsCurrent }

class PieceTile extends StatelessWidget {
  final Piece piece;
  final VoidCallback toggleIsCurrentFunc;
  final VoidCallback onLongPress;
  final bool onMultipleDeleteMode;
  final Function(String) onTapMultipleDelete;
  final bool selected;
  final Isar isar;

  const PieceTile(
      {required this.piece,
      required this.isar,
      required this.toggleIsCurrentFunc,
      required this.onLongPress,
      this.onMultipleDeleteMode = false,
      required this.onTapMultipleDelete,
      this.selected = false,
      Key? key})
      : super(key: key);

  PopupMenuButton _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<PieceTileActions>(
      onSelected: (PieceTileActions selectedOption) {
        if (selectedOption == PieceTileActions.delete) {
          PiecesDatabase(isar: isar).deletePiece(piece, context);
        } else if (selectedOption == PieceTileActions.toggleIsCurrent) {
          // Toggles between current and past
          toggleIsCurrentFunc();
        } else {
          // Edits piece
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPieceScreen(piece: piece, isar: isar),
            ),
          );
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<PieceTileActions>>[
        const PopupMenuItem(value: PieceTileActions.edit, child: Text('Edit')),
        const PopupMenuItem(
            value: PieceTileActions.delete, child: Text('Delete')),
        PopupMenuItem(
            value: PieceTileActions.toggleIsCurrent,
            child: Text(piece.isCurrent ? 'Move to past' : 'Move to current')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Goes to piece info screen (or is selected in multiple delete mode)
      onTap: () async {
        if (onMultipleDeleteMode) {
          //onTapMultipleDelete(piece.id!);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PieceInfoScreen(
                isar: isar,
                piece: piece,
              ),
            ),
          );
        }
      },
      // Long press allows for multiple deletes
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: RoundedWhiteCard(
          padding: const EdgeInsets.all(0.0),
          color: selected ? Colors.blue[200] : null,
          child: ListTile(
            title: Text(piece.title),
            subtitle: Text(piece.composer),
            trailing: onMultipleDeleteMode ? null : _buildPopupMenu(context),
          ),
        ),
      ),
    );
  }
}
