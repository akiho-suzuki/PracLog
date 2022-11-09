import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/log_database.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/logs/widgets/log_card.dart';
import 'package:praclog/ui/practice/pre_practice_screen.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../helpers/datetime_helpers.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

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
                    builder: (context) => const PrePracticeScreen()));
          },
          child: const Text('Start a practice session!'),
        ),
      ],
    );
  }

  LogCard _buildLogCard(Log log) {
    return LogCard(
      log: log,
      onLongPress: () {},
      onTapInMultipleDelete: () {},
      multipleDeleteMode: false,
    );
  }

  //   LogCard _buildLogCard(Log log) {
  //   return LogCard(
  //     log: log,
  //     multipleDeleteMode: _multipleDelete,
  //     isSelected: _multipleDelete ? _selected.contains(log.id) : false,
  //     onTapInMultipleDelete: () {
  //       setState(() {
  //         _selected.contains(log.id)
  //             ? _selected.remove(log.id!)
  //             : _selected.add(log.id!);
  //       });
  //     },
  //     // Toggles to multiple delete mode if it's not already on that
  //     onLongPress: () {
  //       if (_multipleDelete == false) {
  //         _selected.add(log.id!);
  //         setState(() {
  //           _multipleDelete = true;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // The Firestore query
    final query = LogDatabase(
            logCollection: context.watch<AuthManager>().userLogCollection)
        .logCollection
        .orderBy(Label.date, descending: true)
        .withConverter<Log>(
            fromFirestore: (snapshot, _) =>
                Log.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (log, _) => log.toJson());

    // From FlutterFire UI. Has inbuilt pagination feature.
    return FirestoreQueryBuilder<Log>(
      query: query,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        } else if (snapshot.docs.isEmpty) {
          return _buildEmptyLogWidget(context);
        } else {
          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                snapshot.fetchMore();
              }
              final Log log = snapshot.docs[index].data();
              final String dateCategory = log.date.getDateCategory();

              // For logs with date label
              if (index == 0 ||
                  snapshot.docs[index - 1].data().date.getDateCategory() !=
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
              } else if (index == snapshot.docs.length - 1) {
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
      },
    );
  }
}
