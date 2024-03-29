import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/datetime_helpers.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/ui/logs/widgets/log_card.dart';
import 'package:praclog_v2/ui/practice/pre_practice_screen.dart';
import 'package:praclog_v2/ui/widgets/loading_widget.dart';

class LogScreen extends StatefulWidget {
  final Isar isar;
  const LogScreen({super.key, required this.isar});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  // The widget to display if there are any logs
  Widget _buildEmptyLogWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text('No logs found.')),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PrePracticeScreen(isar: widget.isar)));
          },
          child: const Text('Start a practice session!'),
        ),
      ],
    );
  }

  LogCard _buildLogCard(Log log) {
    return LogCard(
      isar: widget.isar,
      log: log,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: LogDatabase(isar: widget.isar).getLogStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Log> logs = snapshot.data!;
          if (logs.isEmpty) {
            return _buildEmptyLogWidget(context);
          } else {
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                Log log = logs[index];
                String dateCategory = log.dateTime.getDateCategory();

                // For logs with date label
                if (index == 0 ||
                    logs[index - 1].dateTime.getDateCategory() !=
                        dateCategory) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(dateCategory)),
                        _buildLogCard(log)
                      ]);
                  // Add space below if it's the last one
                } else if (index == logs.length - 1) {
                  return Column(
                    children: [
                      _buildLogCard(log),
                      kPageBottomSpace,
                    ],
                  );
                } else {
                  return _buildLogCard(log);
                }
              },
            );
          }
        } else {
          return const LoadingWidget();
        }
      },
    );
  }
}
