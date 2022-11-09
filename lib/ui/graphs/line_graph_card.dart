import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:praclog/models/graph_data.dart';
import 'package:praclog/ui/graphs/graph_helper.dart';
import 'package:praclog/ui/graphs/legend_widget.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';

/// For week line graph of ratings. If it's a 7-day graph, the startDay must be provided
class LineGraphCard extends StatefulWidget {
  final RatingsGraphData data;
  final bool landscapeMode;
  // The day to start the graph. Only for short graphs.
  final int? startDay;
  // The date to start the graph. Only for long (landscape) 28-day graphs.
  final DateTime? startDate;

  const LineGraphCard({
    Key? key,
    required this.data,
    this.landscapeMode = false,
    this.startDay,
    this.startDate,
  })  :
        // If it's a 7-day graph, the startDay must be provided
        // If it's a 28 day graph, the startDate must be provided
        assert(landscapeMode ? startDate != null : startDay != null),
        super(key: key);

  @override
  State<LineGraphCard> createState() => _LineGraphCardState();
}

class _LineGraphCardState extends State<LineGraphCard> {
  late bool _showFocus;
  late bool _showProgress;
  late bool _showSatisfaction;

  // Initially show all lines
  @override
  void initState() {
    _showFocus = true;
    _showProgress = true;
    _showSatisfaction = true;
    super.initState();
  }

// Gets y-axis labels
  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

// Builds y-axis label widgets
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontSize: 14,
    );

    return Text(value.toStringAsPrecision(1),
        style: style, textAlign: TextAlign.center);
  }

  // Gets x-axis labels
  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, _) {
          if (widget.landscapeMode) {
            return GraphHelper.monthAxisWidgets(value, widget.startDate!);
          } else {
            return GraphHelper.weekAxisWidgets(value, widget.startDay!);
          }
        },
      );

// Return TitlesData with all axis labels
  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  // A function that turns the data from Summary Stats into FlSpots for the graphs
  List<FlSpot> _getSpotData(List<double?> data) {
    List<FlSpot> list = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] != 0) {
        list.add(FlSpot(i.toDouble(), data[i]!));
      }
    }
    return list;
  }

// Chart data
  LineChartBarData get satisfactionData => LineChartBarData(
        show: _showSatisfaction,
        color: CustomColors.satisfaction,
        spots: _getSpotData(widget.data.satisfactionRatings),
      );
  LineChartBarData get focusData => LineChartBarData(
        show: _showFocus,
        color: CustomColors.focus,
        spots: _getSpotData(widget.data.focusRatings),
      );
  LineChartBarData get progressData => LineChartBarData(
        show: _showProgress,
        color: CustomColors.progress,
        spots: _getSpotData(widget.data.progressRatings),
      );

  Widget _buildChart() => LineChart(
        LineChartData(
          lineBarsData: [
            satisfactionData,
            focusData,
            progressData,
          ],
          minY: 1,
          maxY: 5,
          minX: -0.6,
          maxX: widget.data.focusRatings.length - 0.4,
          titlesData: titlesData1,
          gridData: GraphHelper.getGridData(widget.landscapeMode, 1.0),
          lineTouchData: LineTouchData(enabled: false),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteCard(
      padding: const EdgeInsets.fromLTRB(0, 20.0, 20.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.landscapeMode
              ? Flexible(child: _buildChart())
              : AspectRatio(
                  aspectRatio: 1.6,
                  child: _buildChart(),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendWidget(
                  text: 'Satisfaction',
                  color: CustomColors.satisfaction,
                  active: _showSatisfaction,
                  onPressed: () {
                    setState(() {
                      _showSatisfaction = _showSatisfaction ? false : true;
                    });
                  }),
              LegendWidget(
                  text: 'Focus',
                  color: CustomColors.focus,
                  active: _showFocus,
                  onPressed: () {
                    setState(() {
                      _showFocus = _showFocus ? false : true;
                    });
                  }),
              LegendWidget(
                  text: 'Progress',
                  color: CustomColors.progress,
                  active: _showProgress,
                  onPressed: () {
                    setState(() {
                      _showProgress = _showProgress ? false : true;
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
