import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:praclog_v2/constants.dart';
import '../../../helpers/datetime_helpers.dart';

// Types for Summary Stats
enum SummaryStatsType { lastSevenDays, lastThirtyDays, lastTwelveMonths }

class GraphHelper {
  static final List<String> _week = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  static List<String> _getDayLabels(int endWeekDay) {
    List<String> partA = _week.sublist(endWeekDay);
    List<String> partB = _week.sublist(0, endWeekDay);
    return partA + partB;
  }

  /// Builds x-axis label widgets for a week (Mon - Sun)
  static Widget weekAxisWidgets(double value, int currentWeekDay) {
    const style = TextStyle(
      color: kLightTextColor,
      fontSize: 14,
    );

    List<String> weekLabels =
        currentWeekDay == 7 ? _week : _getDayLabels(currentWeekDay);

    Widget text;
    switch (value.round()) {
      case 0:
        text = Text(weekLabels[0], style: style);
        break;
      case 1:
        text = Text(weekLabels[1], style: style);
        break;
      case 2:
        text = Text(weekLabels[2], style: style);
        break;
      case 3:
        text = Text(weekLabels[3], style: style);
        break;
      case 4:
        text = Text(weekLabels[4], style: style);
        break;
      case 5:
        text = Text(weekLabels[5], style: style);
        break;
      case 6:
        text = Text(weekLabels[6], style: style);
        break;
      default:
        text = const Text('');
    }

    return Padding(padding: const EdgeInsets.only(top: 10.0), child: text);
  }

// Builds x-axid label widgets for a month (date every 7 days)
  static Widget monthAxisWidgets(double value, DateTime lastDate) {
    String text;
    switch (value.round()) {
      case 0:
        text = lastDate.getNWeekBefore(4).getDateMonth();
        break;
      case 6:
        text = lastDate.getNWeekBefore(3).getDateMonth();
        break;
      case 13:
        text = lastDate.getNWeekBefore(2).getDateMonth();
        break;
      case 20:
        text = lastDate.getNWeekBefore(1).getDateMonth();
        break;
      case 27:
        text = lastDate.getDateMonth();
        break;
      default:
        text = '';
    }
    return Text(text);
  }

  // Axis label helpers
  static double maxX(SummaryStatsType type) {
    if (type == SummaryStatsType.lastSevenDays) {
      return 6.6;
    } else {
      return 29.6;
    }
  }

  static FlGridData getGridData(
      bool landscapeMode, double? horizontalInterval) {
    if (landscapeMode) {
      return FlGridData(
          verticalInterval: 1.0,
          horizontalInterval: horizontalInterval,
          checkToShowVerticalLine: (double x) {
            switch (x.round()) {
              case 0:
                return true;
              case 6:
                return true;
              case 13:
                return true;
              case 20:
                return true;
              case 27:
                return true;
              default:
                return false;
            }
          });
    } else {
      return FlGridData(
          drawVerticalLine: false, horizontalInterval: horizontalInterval);
    }
  }
}
