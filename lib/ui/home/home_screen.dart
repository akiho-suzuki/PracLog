import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:praclog/models/graph_data.dart';
import 'package:praclog/models/week_data.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/week_data_database.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/graphs/bar_graph_card.dart';
import 'package:praclog/ui/graphs/line_graph_card.dart';
import 'package:praclog/ui/home/graph_screen.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:praclog/ui/widgets/ratings_tiles.dart';
import 'package:praclog/ui/widgets/stats_tiles_grid.dart';
import 'package:provider/provider.dart';

enum _StatsScreenDisplayOption { last7days, thisWeek }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late _StatsScreenDisplayOption _displayOption;

  @override
  void initState() {
    _displayOption = _StatsScreenDisplayOption.thisWeek;
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
            _displayOption = type;
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
            ]);
  }

  Future onPressedMoreGraph() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const GraphScreen()));
    // Set orientation back to portrait
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    AuthManager authManager = context.watch<AuthManager>();
    return StreamBuilder<List<WeekData>>(
      stream: WeekDataDatabase(
              weekDataCollection: authManager.userWeekDataCollection)
          .last7DaysStream(DateTime.now()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasData) {
          List<WeekData> data;
          int day;
          if (_displayOption == _StatsScreenDisplayOption.last7days) {
            day = DateTime.now().weekday;
            data = snapshot.data!;
          } else {
            // To show this week (Mon - Sun), set day to Sunday
            day = 7;
            data = [snapshot.data!.last];
          }
          StatsSummaryData statsSummaryData =
              WeekData.generateLast7DaysStatsSummaryData(snapshot.data!, day);

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
                        data: '${statsSummaryData.totalDuration} hours',
                        text: 'total duration'),
                  ),
                  const SizedBox(width: 7.0),
                  Expanded(
                    child: StatsTile(
                        data: '${statsSummaryData.averageDuration} minutes',
                        iconData: kTimeIcon,
                        text: 'average duration'),
                  ),
                ],
              ),
              kLowerSpacing,
              RatingsTilesRow(
                  satisfaction: statsSummaryData.satisfaction,
                  focus: statsSummaryData.focus,
                  progress: statsSummaryData.progress),
              kUpperSpacing,
              const Text('Ratings', style: kSubheading),
              kLowerSpacing,
              LineGraphCard(
                data: WeekData.generateRatingsGraphData(
                    data, day, GraphDateType.last7Days),
                startDay: day,
              ),
              kUpperSpacing,
              const Text('Practice durations', style: kSubheading),
              kLowerSpacing,
              BarGraphCard(
                data: WeekData.generateDurationGraphData(
                    data, day, GraphDateType.last7Days),
                startDay: day,
              ),
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
