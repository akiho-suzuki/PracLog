import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/datetime_helpers.dart';
import 'package:praclog_v2/services/data_import_export.dart';
import 'package:praclog_v2/ui/widgets/custom_scaffold.dart';
import 'package:praclog_v2/ui/widgets/main_button.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';
import 'package:praclog_v2/utils/show_snackbar.dart';

class DataExportScreen extends StatefulWidget {
  final Isar isar;
  const DataExportScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends State<DataExportScreen> {
  late DateTimeRange _chosenDateRange;

  late bool _exportAll;

  String get _dateRangeAsString =>
      'From ${_chosenDateRange.start.getDateOnly()} to ${_chosenDateRange.end.getDateOnly()}';

  @override
  void initState() {
    _chosenDateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    _exportAll = false;
    super.initState();
  }

  Future _exportData() async {
    bool response = await DataImportExport(isar: widget.isar)
        .exportData(_exportAll ? null : _chosenDateRange);
    if (response && mounted) {
      showSnackBar(context, "Data shared successfully!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Export my data',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Date Range', style: kSubheading),
              TextButton(
                child: const Text('Select all data'),
                onPressed: () {
                  setState(() {
                    _exportAll = true;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          RoundedWhiteCard(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_exportAll ? 'All data' : _dateRangeAsString),
                  const Icon(Icons.calendar_month_outlined),
                ],
              ),
              onTap: () async {
                DateTimeRange? result = await showDialog(
                  context: context,
                  builder: (context) => Theme(
                    data: ThemeData(),
                    child: DateRangePickerDialog(
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now(),
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _exportAll = false;
                    _chosenDateRange = result;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 15.0),
          MainButton(
            onPressed: () {
              _exportData();
            },
            text: 'Export data',
          ),
        ],
      ),
    );
  }
}
