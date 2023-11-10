import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/datetime_helpers.dart';
import 'package:praclog_v2/models/ratings_graph_data.dart';
import 'package:praclog_v2/models/log_stats.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/ui/graphs/bar_graph_card.dart';
import 'package:praclog_v2/ui/graphs/line_graph_card.dart';
import 'package:praclog_v2/ui/home/graph_screen.dart';
import 'package:praclog_v2/ui/widgets/loading_widget.dart';
import 'package:praclog_v2/ui/widgets/ratings_tiles.dart';
import 'package:praclog_v2/ui/widgets/stats_tile.dart';

enum _StatsScreenDisplayOption { last7days, thisWeek }

class HomeScreen extends StatefulWidget {
  final Isar isar;
  const HomeScreen({required this.isar, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late _StatsScreenDisplayOption _displayOption;
  late DateTime endDate;

  @override
  void initState() {
    _displayOption = _StatsScreenDisplayOption.last7days;
    endDate = DateTime.now();
    super.initState();
  }

  PopupMenuButton _buildDateMenuButton() {
    const String last7Days = "Last 7 days";
    const String thisWeek = "This week";
    String text = _displayOption == _StatsScreenDisplayOption.last7days
        ? last7Days
        : thisWeek;

    return PopupMenuButton<_StatsScreenDisplayOption>(
      child: Row(
        children: [
          Text(text),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      onSelected: (_StatsScreenDisplayOption type) {
        setState(() {
          // If there is a change
          if (_displayOption != type) {
            _displayOption = type;
            endDate = _displayOption == _StatsScreenDisplayOption.last7days
                ? DateTime.now()
                : DateTime.now().getThisSun();
          }
        });
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_StatsScreenDisplayOption>(
          value: _StatsScreenDisplayOption.last7days,
          child: Text(last7Days),
        ),
        const PopupMenuItem<_StatsScreenDisplayOption>(
          value: _StatsScreenDisplayOption.thisWeek,
          child: Text(thisWeek),
        ),
      ],
    );
  }

  Future onPressedMoreGraph() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GraphScreen(isar: widget.isar)));
    // Set orientation back to portrait
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = endDate.getNWeekBefore(1).add(const Duration(days: 1));
    return StreamBuilder<List<Log>>(
      stream: LogDatabase(isar: widget.isar).getWeekLogStream(
          startDate.setAtStartOfDay(), endDate.setAtEndOfDay()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasData) {
          List<Log> logs = snapshot.data!;
          LogStats logStats = LogStats.fromLogs(logs);
          GraphData graphData =
              GraphData.getRatingsGraphData(logs, startDate, endDate);

          return ListView(
            children: [
              kUpperSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Week summary', style: kSubheading),
                  _buildDateMenuButton(),
                ],
              ),
              kLowerSpacing,
              Row(
                children: [
                  Expanded(
                    child: StatsTile(
                        iconData: kTimeIcon,
                        data: '${logStats.totalDurationInHours} hours',
                        text: 'total duration'),
                  ),
                  const SizedBox(width: 7.0),
                  Expanded(
                    child: StatsTile(
                        data: '${logStats.averageDurationAsString} minutes',
                        iconData: kTimeIcon,
                        text: 'average duration'),
                  ),
                ],
              ),
              kLowerSpacing,
              RatingsTilesRow(
                  satisfaction: logStats.averageSatisfactionAsString,
                  focus: logStats.averageFocusAsString,
                  progress: logStats.averageProgressAsString),
              kUpperSpacing,
              const Text('Ratings', style: kSubheading),
              kLowerSpacing,
              LineGraphCard(
                data: graphData,
                startDay: endDate.weekday,
              ),
              kUpperSpacing,
              const Text('Practice durations', style: kSubheading),
              kLowerSpacing,
              BarGraphCard(data: graphData, startDay: endDate.weekday),
              TextButton(
                onPressed: () => onPressedMoreGraph(),
                child: const Text('See more graphs'),
              ),
              kLowerSpacing,
            ],
          );
        } else {
          return const Text('Error');
        }
      },
    );
  }
}
