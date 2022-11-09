import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:praclog/models/week_data.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/week_data_database.dart';
import 'package:praclog/ui/graphs/bar_graph_card.dart';
import 'package:praclog/ui/graphs/line_graph_card.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/custom_scaffold.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../helpers/datetime_helpers.dart';

enum _InfoType { ratings, duration }

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

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

  // Fetch necessary data from Firestore
  Future<List<WeekData>> _getData(AuthManager authManager) {
    return WeekDataDatabase(
            weekDataCollection: authManager.userWeekDataCollection)
        .last28DaysData(_showFromDate);
  }

  // Build the graph, according to whether the user has chosen to see ratings or durations
  Widget _buildGraph(List<WeekData> data) {
    // Ratings for last 28 days
    if (_infoType == _InfoType.ratings) {
      return LineGraphCard(
        landscapeMode: true,
        data: WeekData.generateRatingsGraphData(
            data, DateTime.now().weekday, GraphDateType.last28Days),
        startDate: _showFromDate,
      );
      // Durations for last 28 days
    } else {
      return BarGraphCard(
        landscapeMode: true,
        data: WeekData.generateDurationGraphData(
            data, DateTime.now().weekday, GraphDateType.last28Days),
        startDate: _showFromDate,
      );
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

  bool _enableDateBackward(AuthManager authManager) {
    // TODO if accountCreationDate is null, it is currently set at 2022-09-01
    DateTime accountCreationDate =
        authManager.accountCreationDate ?? DateTime.utc(2022, 09, 01);
    return _showFromDate.isAfter(accountCreationDate);
  }

  @override
  Widget build(BuildContext context) {
    AuthManager authManager = context.watch<AuthManager>();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    return CustomScaffold(
      appBarTrailing: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              _enableDateBackward(authManager) ? () => onPressDateBack() : null,
          disabledColor: CustomColors.lightTextColor,
        ),
        Center(
            child: Text(dateRange,
                style: const TextStyle(fontWeight: FontWeight.bold))),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _enableDateForward() ? () => onPressDateForward() : null,
          disabledColor: CustomColors.lightTextColor,
        ),
        const SizedBox(width: 15.0),
        _buildTypeMenuButton(),
      ],
      body: FutureBuilder<List<WeekData>>(
        future: _getData(authManager),
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
