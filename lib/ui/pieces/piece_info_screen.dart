import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/null_empty_helpers.dart';
import 'package:praclog_v2/models/log_stats.dart';
import 'package:praclog_v2/services/pieces_database.dart';
import 'package:praclog_v2/ui/pieces/edit_piece_screen.dart';
import 'package:praclog_v2/ui/widgets/custom_scaffold.dart';
import 'package:praclog_v2/ui/widgets/loading_widget.dart';
import 'package:praclog_v2/ui/widgets/ratings_tiles.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';
import 'package:praclog_v2/ui/widgets/stats_tile.dart';

class PieceInfoScreen extends StatefulWidget {
  final Piece piece;
  final Isar isar;

  const PieceInfoScreen({
    Key? key,
    required this.isar,
    required this.piece,
  }) : super(key: key);

  @override
  State<PieceInfoScreen> createState() => _PieceInfoScreenState();
}

class _PieceInfoScreenState extends State<PieceInfoScreen> {
  late int _selectedMovement; // -1 means no movement

  @override
  void initState() {
    _selectedMovement = -1;
    super.initState();
  }

  Future<LogStats> _getPieceStats() async {
    // Load the pieces if they are not already loaded
    if (!widget.piece.logs.isLoaded) {
      await widget.piece.logs.load();
    }
    // If there are no logs
    if (widget.piece.logs.isEmpty) {
      return LogStats.empty();
    } else {
      List<Log> logs = [];
      for (Log log in widget.piece.logs) {
        logs.add(log);
      }
      return PiecesDatabase(isar: widget.isar)
          .getPieceStats(logs, _selectedMovement);
    }
  }

  void onPressDelete() async {
    await PiecesDatabase(isar: widget.isar).deletePiece(widget.piece, context);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Piece Info',
      appBarTrailing: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditPieceScreen(isar: widget.isar, piece: widget.piece),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            onPressDelete();
          },
        ),
      ],
      body: ListView(
        children: [
          PieceInfoCard(
            piece: widget.piece,
            onTapMovement: widget.piece.movements.isNotNullOrEmpty
                ? (int mvt) {
                    setState(() {
                      _selectedMovement = mvt;
                    });
                  }
                : null,
          ),
          const SizedBox(height: 15.0),
          const Text('Summary stats', style: kSubheading),
          const SizedBox(height: 10.0),
          FutureBuilder<LogStats>(
            future: _getPieceStats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else if (snapshot.hasData) {
                LogStats pieceStats = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatsTile(
                              iconData: Icons.calendar_month,
                              data:
                                  '${pieceStats.daysSinceLearningAsString} days',
                              text: 'since learning'),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: StatsTile(
                              iconData: kTimeIcon,
                              data: '${pieceStats.totalSessions} sessions',
                              text: 'total sessions'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: StatsTile(
                              iconData: kTimeIcon,
                              data: '${pieceStats.averageDurationAsString} min',
                              text: 'average duration'),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: StatsTile(
                              iconData: kTimeIcon,
                              data: '${pieceStats.totalDurationInHours} hours',
                              text: 'total duration'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    const Text('Average ratings', style: kSubheading),
                    const SizedBox(height: 10.0),
                    RatingsTilesRow(
                        satisfaction: pieceStats.averageSatisfactionAsString,
                        focus: pieceStats.averageFocusAsString,
                        progress: pieceStats.averageProgressAsString),
                  ],
                );
              } else {
                return const Text('Error');
              }
            },
          ),
        ],
      ),
    );
  }
}

// TODO: It would be nice to have the expansion tile collapse automatically when user selects something. This is not supported in the flutter `ExpansionTile` right now so you would need to create/tweak own widget. Maybe in the future.
class PieceInfoCard extends StatefulWidget {
  final Piece piece;
  final Function(int)? onTapMovement;

  PieceInfoCard({
    Key? key,
    required this.piece,
    this.onTapMovement,
  })  : assert(piece.movements.isNotNullOrEmpty ? onTapMovement != null : true),
        super(key: key);

  @override
  State<PieceInfoCard> createState() => _PieceInfoCardState();
}

class _PieceInfoCardState extends State<PieceInfoCard> {
  int? _selectedMovement;
  late bool _isExpanded;

  TextStyle _getSelectedTextStyle() {
    return const TextStyle(
      color: Colors.blue,
    );
  }

  @override
  void initState() {
    _isExpanded = false;
    super.initState();
  }

  // Only call if widget.piece has movements.
  List<ListTile> buildListTiles() {
    List<ListTile> list = [];
    List<String> movements = widget.piece.movements!;

    for (int i = 0; i < movements.length; i++) {
      list.add(
        ListTile(
          title: Text('${i + 1}. ${movements[i]}',
              style: (_selectedMovement != null && _selectedMovement == i)
                  ? _getSelectedTextStyle()
                  : null),
          onTap: () {
            setState(() {
              _selectedMovement = i;
            });
            widget.onTapMovement!(i);
          },
        ),
      );
    }

    if (_selectedMovement != null) {
      list.add(ListTile(
        title: Text('Show stats for whole piece',
            style: TextStyle(color: Colors.grey[400])),
        onTap: () {
          setState(() {
            _selectedMovement = null;
          });
          widget.onTapMovement!(-1);
        },
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.piece.movements.isNotNullOrEmpty) {
      return RoundedWhiteCard(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(widget.piece.toString()),
            subtitle: (_isExpanded == false && _selectedMovement != null)
                ? Text(
                    '${_selectedMovement! + 1}. ${widget.piece.movements![_selectedMovement!]}')
                : null,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.centerLeft,
            onExpansionChanged: (bool v) {
              setState(() {
                _isExpanded = v;
              });
            },
            children:
                ListTile.divideTiles(context: context, tiles: buildListTiles())
                    .toList(),
          ),
        ),
      );
    } else {
      return RoundedWhiteCard(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          widget.piece.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      );
    }
  }
}
