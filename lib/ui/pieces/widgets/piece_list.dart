import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/services/pieces_database.dart';
import 'package:praclog_v2/ui/pieces/past_pieces_screen.dart';
import 'package:praclog_v2/ui/pieces/widgets/piece_tile.dart';
import 'package:praclog_v2/ui/widgets/loading_widget.dart';
import 'package:praclog_v2/utils/show_add_piece_sheet.dart';

enum RepertoireScreenMoreOptions { deleteAll, showPast }

/// Builds list of pieces.
///
/// Set `showCurrent` to `true` for `RepertoireScreen`. This shows current repertoire, with a button to add new pieces and a dropdownmenu to sort by title or composer. There is no scaffold provided as it is one of the main screens accessed using the bottom navigation bar.
///
/// Set `showCurrent` to `false` for `PastRepertoireScreen`. This shows past repertoire with the dropdownmenu. There is no option to add new pieces and it comes within a scaffold.
class PieceList extends StatefulWidget {
  final Isar isar;
  final bool showCurrent;
  const PieceList({super.key, required this.isar, required this.showCurrent});

  @override
  State<PieceList> createState() => _PieceListState();
}

class _PieceListState extends State<PieceList> {
  PiecesSortBy _chosenSort = PiecesSortBy.composer;

  TextStyle _sortByOptionTextStyle(PiecesSortBy option) {
    return TextStyle(
        color: _chosenSort == option ? kPrimaryColor : kLightTextColor);
  }

  // The dropdown menu on the top that allows users to sort list
  // see past repertoire and TODO delete all pieces
  PopupMenuButton _buildMoreButton(bool current) {
    List<PopupMenuEntry> entries = [
      const PopupMenuItem(child: Text('Sort by:')),
      PopupMenuItem(
        value: PiecesSortBy.title,
        child: Text('Title', style: _sortByOptionTextStyle(PiecesSortBy.title)),
      ),
      PopupMenuItem(
        value: PiecesSortBy.composer,
        child: Text('Composer',
            style: _sortByOptionTextStyle(PiecesSortBy.composer)),
      ),
      const PopupMenuDivider(),
      // const PopupMenuItem(
      //   value: RepertoireScreenMoreOptions.deleteAll,
      //   child: Text('Delete all pieces'),
      // ),
    ];

    if (current) {
      entries.add(
        const PopupMenuItem(
          value: RepertoireScreenMoreOptions.showPast,
          child: Text('See past pieces'),
        ),
      );
    }

    return PopupMenuButton(
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Options'),
          Icon(Icons.arrow_drop_down),
        ],
      ),
      onSelected: (chosenOption) {
        switch (chosenOption) {
          case PiecesSortBy.title:
            {
              setState(() {
                _chosenSort = PiecesSortBy.title;
              });
            }
            break;
          case PiecesSortBy.composer:
            {
              setState(() {
                _chosenSort = PiecesSortBy.composer;
              });
            }
            break;
          // case RepertoireScreenMoreOptions.deleteAll:
          //   {}
          //   break;
          case RepertoireScreenMoreOptions.showPast:
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PastPiecesScreen(isar: widget.isar),
                ),
              );
            }
            break;
        }
      },
      itemBuilder: (context) => entries,
    );
  }

  // Widget to show when list is empty
  Widget _buildEmptyListWidget() {
    if (widget.showCurrent) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Your repertoire list is empty :(',
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              showAddPieceSheet(context, widget.isar);
            },
            child: const Text('Tap me to add your first piece!'),
          ),
        ],
      );
    } else {
      return const Center(
        child:
            Text('When you are no longer working on a piece, mark it as past'),
      );
    }
  }

  // Widget(s) to display at the top of the list (add new piece, options dropdown)
  Widget _buildTopWidgets() {
    if (widget.showCurrent) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Add new piece button
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(kLightTextColor),
            ),
            icon: const Icon(Icons.add_circle_outline, size: 18.0),
            label: const Text('Add a new piece'),
            onPressed: () {
              showAddPieceSheet(context, widget.isar);
            },
          ),
          // Sort by dropdown
          _buildMoreButton(true),
        ],
      );
    } else {
      return _buildMoreButton(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Piece>?>(
      stream: PiecesDatabase(isar: widget.isar)
          .getSortedPiecesStream(_chosenSort, showCurrent: widget.showCurrent),
      builder: (context, snapshot) {
        // If loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasData) {
          // If there are pieces
          if (snapshot.data!.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTopWidgets(),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Piece piece = snapshot.data![index];
                      return PieceTile(
                        piece: piece,
                        isar: widget.isar,
                        toggleIsCurrentFunc: () async {
                          await PiecesDatabase(isar: widget.isar)
                              .toggleIsCurrent(piece);
                        },
                        onLongPress: () {},
                        onTapMultipleDelete: (v) {},
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            // If there are no pieces
            return _buildEmptyListWidget();
          }
        } else {
          return const Center(child: Text('Error'));
        }
      },
    );
  }
}
