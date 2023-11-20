import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/models/ratings_graph_data.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/ui/graphs/bar_graph_card.dart';
import 'package:praclog_v2/ui/graphs/line_graph_card.dart';
import 'package:praclog_v2/ui/widgets/custom_scaffold.dart';
import 'package:praclog_v2/ui/widgets/loading_widget.dart';
import '../../helpers/datetime_helpers.dart';

enum _InfoType { ratings, duration }

class GraphScreen extends StatefulWidget {
  final Isar isar;
  const GraphScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late _InfoType _infoType;
  late DateTime _showFromDate;

  @override
  void initState() {
    _infoType = _InfoType.ratings;
    _showFromDate = DateTime.now();
    super.initState();
  }

  // Pop up menu to let the user choose whether to see ratings or durations
  PopupMenuButton _buildTypeMenuButton() {
    String text = '';
    switch (_infoType) {
      case _InfoType.duration:
        text = 'Durations';
        break;
      case _InfoType.ratings:
        text = 'Ratings';
        break;
    }

    return PopupMenuButton<_InfoType>(
        child: Row(
          children: [
            Text(text),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
        onSelected: (_InfoType type) {
          setState(() {
            _infoType = type;
          });
        },
        itemBuilder: (context) => [
              const PopupMenuItem<_InfoType>(
                value: _InfoType.duration,
                child: Text('Durations'),
              ),
              const PopupMenuItem<_InfoType>(
                value: _InfoType.ratings,
                child: Text('Rating'),
              )
            ]);
  }

  // Build the graph, according to whether the user has chosen to see ratings or durations
  Widget _buildGraph(List<Log> logs) {
    GraphData graphData = GraphData.getRatingsGraphData(
        logs, _showFromDate.getNWeekBefore(4), _showFromDate);
    // Ratings for last 28 days
    if (_infoType == _InfoType.ratings) {
      return LineGraphCard(
        landscapeMode: true,
        data: graphData,
        startDate: _showFromDate,
      );
      // Durations for last 28 days
    } else {
      return BarGraphCard(
          landscapeMode: true, data: graphData, startDate: _showFromDate);
    }
  }

  // String for appBar to show the date range of the graph being shown
  String get dateRange {
    return '${_showFromDate.getNWeekBefore(4).getDateOnly()} - ${_showFromDate.getDateOnly()}';
  }

  // Sets the _showFromDate four weeks (28 days) prior to the current one
  void onPressDateBack() {
    setState(() {
      _showFromDate = _showFromDate.getNWeekBefore(4);
    });
  }

  // Sets the _showFromDate four weeks (28 days) after to the current one.
  void onPressDateForward() {
    setState(() {
      _showFromDate = _showFromDate.getNWeekAfter(4);
    });
  }

  bool _enableDateForward() => !_showFromDate.isSameDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    return CustomScaffold(
      appBarTrailing: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => onPressDateBack(),
          // disabledColor: kLightTextColor,
        ),
        Center(
            child: Text(dateRange,
                style: const TextStyle(fontWeight: FontWeight.bold))),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _enableDateForward() ? () => onPressDateForward() : null,
          disabledColor: kLightTextColor,
        ),
        const SizedBox(width: 15.0),
        _buildTypeMenuButton(),
      ],
      body: FutureBuilder<List<Log>>(
        future: LogDatabase(isar: widget.isar)
            .getLogsBetween(_showFromDate.getNWeekBefore(4), _showFromDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasData) {
            return _buildGraph(snapshot.data!);
          } else {
            return const Text('Error');
          }
        },
      ),
    );
  }
}
