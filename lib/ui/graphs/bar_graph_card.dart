import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/graph_helper.dart';
import 'package:praclog_v2/models/ratings_graph_data.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

class BarGraphCard extends StatefulWidget {
  final GraphData data;
  final bool landscapeMode;
  // The day to start the graph. Only for short 7-day graphs.
  final int? startDay;
  // The date to start the graph. Only for long (landscape) 28-day graphs.
  final DateTime? startDate;
  const BarGraphCard({
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
  State<BarGraphCard> createState() => _BarGraphCardState();
}

class _BarGraphCardState extends State<BarGraphCard> {
  final List<Color> _colors = [
    Colors.lightBlue[900]!,
    Colors.lightBlue[600]!,
    Colors.lightBlue[200]!
  ];

  Color _getColor(int n) {
    return _colors[n < _colors.length ? n : n % _colors.length];
  }

  BarChartGroupData _getDayData(int x) {
    double total = widget.data.dayTotals[x];
    List<BarChartRodStackItem> rodStackItems = [];
    if (total != 0) {
      double current = 0;
      int i = 0;
      for (int n in widget.data.dayDurationData[x]) {
        rodStackItems
            .add(BarChartRodStackItem(current, current + n, _getColor(i)));
        current += n;
        i++;
      }
    }

    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: widget.data.dayTotals[x],
        rodStackItems: rodStackItems,
      )
    ]);
  }

  List<BarChartGroupData> getData() {
    List<BarChartGroupData> list = [];
    for (int i = 0; i < widget.data.dayTotals.length; i++) {
      list.add(_getDayData(i));
    }
    return list;
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

// Builds y-axis label widgets
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: kLightTextColor,
      fontSize: 14,
    );

    String string = '';
    if (value % 60 == 0) {
      double hour = value / 60;
      string = '${hour.round()} h';
    }

    if (_showSmallYAxis && value.round() == 30) {
      string = '30 m';
    }
    return Text(string, style: style, textAlign: TextAlign.center);
  }

  // Gets y-axis labels
  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        // Interval is 30 minutes if max Y is less than 1 hours, otherwise interval is 60 minutes
        interval: _showSmallYAxis ? 30 : 60,
        reservedSize: 40,
      );

// Returns true if max Y is less than 1 hour
  bool get _showSmallYAxis => widget.data.maxDayTotal() < 60.0;

// Return TitlesData with all axis labels
  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  BarChart _buildChart() => BarChart(
        BarChartData(
          barGroups: getData(),
          minY: 0.0,
          maxY: _showSmallYAxis ? 60.0 : widget.data.maxDayTotal(),
          titlesData: titlesData1,
          barTouchData: BarTouchData(enabled: false),
          gridData: GraphHelper.getGridData(
              widget.landscapeMode, _showSmallYAxis ? 30.0 : 60.0),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GraphCardTemplate(
      child: widget.landscapeMode
          ? Flexible(child: _buildChart())
          : AspectRatio(
              aspectRatio: 1.6,
              child: _buildChart(),
            ),
    );
  }
}

class GraphCardTemplate extends StatelessWidget {
  final Widget child;
  const GraphCardTemplate({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteCard(
        padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 20.0), child: child);
  }
}
