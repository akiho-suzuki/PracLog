import 'package:flutter/material.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/repertoire_database.dart';
import 'package:praclog/ui/repertoire/past_repertoire_screen.dart';
import 'package:praclog/ui/repertoire/widgets/piece_tile.dart';
import 'package:praclog/ui/utils/show_add_piece_bottomsheet.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:praclog/ui/theme/custom_colors.dart';

enum RepertoireScreenMoreOptions { deleteAll, showPast }

/// Builds list of user's pieces.
///
/// Set `showCurrent` to `true` for `RepertoireScreen`. This shows current repertoire, with a button to add new pieces and a dropdownmenu to sort by title or composer. There is no scaffold provided as it is one of the main screens accessed using the bottom navigation bar.
///
/// Set `showCurrent` to `false` for `PastRepertoireScreen`. This shows past repertoire with the dropdownmenu. There is no option to add new pieces and it comes within a scaffold.
class RepertoireList extends StatefulWidget {
  final bool showCurrent;
  const RepertoireList({
    Key? key,
    required this.showCurrent,
  }) : super(key: key);

  @override
  State<RepertoireList> createState() => _RepertoireListState();
}

class _RepertoireListState extends State<RepertoireList> {
  late RepertoireListSortBy _chosenSort;

  @override
  void initState() {
    _chosenSort = RepertoireListSortBy.title;
    super.initState();
  }

  PopupMenuButton _buildMoreButton(bool current) {
    List<PopupMenuEntry> entries = [
      const PopupMenuItem(child: Text('Sort by:')),
      PopupMenuItem(
        value: RepertoireListSortBy.title,
        child: Text('Title',
            style: sortByOptionTextStyle(RepertoireListSortBy.title)),
      ),
      PopupMenuItem(
        value: RepertoireListSortBy.composer,
        child: Text('Composer',
            style: sortByOptionTextStyle(RepertoireListSortBy.composer)),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Options'),
          Icon(Icons.arrow_drop_down),
        ],
      ),
      onSelected: (chosenOption) {
        switch (chosenOption) {
          case RepertoireListSortBy.title:
            {
              setState(() {
                _chosenSort = RepertoireListSortBy.title;
              });
            }
            break;
          case RepertoireListSortBy.composer:
            {
              setState(() {
                _chosenSort = RepertoireListSortBy.composer;
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
                  builder: (context) => const PastRepertoireScreen(),
                ),
              );
            }
            break;
        }
      },
      itemBuilder: (context) => entries,
    );
  }

  TextStyle sortByOptionTextStyle(RepertoireListSortBy option) {
    return TextStyle(
        color: _chosenSort == option
            ? CustomColors.primaryColor
            : CustomColors.lightTextColor);
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
              showAddPieceBottomSheet(context);
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
                  MaterialStateProperty.all<Color>(CustomColors.lightTextColor),
            ),
            icon: const Icon(Icons.add_circle_outline, size: 18.0),
            label: const Text('Add a new piece'),
            onPressed: () {
              showAddPieceBottomSheet(context);
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
    AuthManager authManager = context.watch<AuthManager>();
    // This is RepertoireDatabase for current user's repertoire
    RepertoireDatabase repertoireDatabase = RepertoireDatabase(
        repertoireCollection: authManager.userRepertoireCollection);

    return StreamBuilder<List<Piece>?>(
      stream: repertoireDatabase.getSortedPiecesStream(_chosenSort,
          showCurrent: widget.showCurrent),
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
                        toggleIsCurrentFunc: () async {
                          await repertoireDatabase.toggleIsCurrent(piece);
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
