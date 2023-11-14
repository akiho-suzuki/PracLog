import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/ui/logs/widgets/log_card.dart';

class LogScreen extends StatefulWidget {
  final Isar isar;
  const LogScreen({super.key, required this.isar});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  static const _pageSize = 10;

  final PagingController<int, Log> _pagingController =
      PagingController(firstPageKey: 0);
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    // Watch changes in logs and refresh the page if there are any changes
    Stream<void> logChanges =
        LogDatabase(isar: widget.isar).watchLogListChanges();
    streamSubscription = logChanges.listen((_) {
      _pagingController.refresh();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await LogDatabase(isar: widget.isar)
          .getLogsInBatches(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Log>(
          itemBuilder: (context, item, index) {
            return LogCard(
                isar: widget.isar,
                log: item,
                onLongPress: () {},
                multipleDeleteMode: false,
                onTapInMultipleDelete: () {});
          },
        ),
      ),
    );
  }
}
