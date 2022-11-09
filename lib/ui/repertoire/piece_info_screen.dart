import 'package:flutter/material.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/models/piece_stats.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/log_database.dart';
import 'package:praclog/services/database/piece_stats.database.dart';
import 'package:praclog/services/database/repertoire_database.dart';
import 'package:praclog/services/database/week_data_database.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/repertoire/edit_piece_screen.dart';
import 'package:praclog/ui/widgets/custom_scaffold.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:praclog/ui/widgets/ratings_tiles.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:praclog/ui/widgets/stats_tiles_grid.dart';
import 'package:provider/provider.dart';
import '../../helpers/null_empty_helper.dart';

class PieceInfoScreen extends StatefulWidget {
  final Piece piece;

  const PieceInfoScreen({
    Key? key,
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

  Future<PieceStats> _getPieceStats(AuthManager authManager) async {
    PieceStatsDatabase pieceStatsDatabase = PieceStatsDatabase(
        authManager.userPieceStatsCollection(widget.piece.id!));

    var result = await pieceStatsDatabase.convertedPieceStatsCollection
        .where(Label.pieceStatsType, isEqualTo: _selectedMovement)
        .get();

    if (result.docs.isEmpty) {
      return PieceStats.empty(_selectedMovement);
    } else {
      return result.docs.first.data() as PieceStats;
    }
  }

  void onPressDelete(AuthManager authManager) async {
    await Piece.deletePiece(
      context: context,
      piece: widget.piece,
      repertoireDatabase: RepertoireDatabase(
          repertoireCollection: authManager.userRepertoireCollection),
      logDatabase: LogDatabase(logCollection: authManager.userLogCollection),
      weekDataDatabase: WeekDataDatabase(
          weekDataCollection: authManager.userWeekDataCollection),
    );
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
                builder: (context) => EditPieceScreen(piece: widget.piece),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            onPressDelete(context.read<AuthManager>());
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
          FutureBuilder<PieceStats>(
            future: _getPieceStats(context.watch<AuthManager>()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else if (snapshot.hasData) {
                PieceStats pieceStats = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatsTile(
                              iconData: Icons.calendar_month,
                              data: '${pieceStats.daysSinceLearning} days',
                              text: 'since learning'),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: StatsTile(
                              iconData: kTimeIcon,
                              data: '${pieceStats.nSessions} sessions',
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
                              data: '${pieceStats.averageMinAsString} min',
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
