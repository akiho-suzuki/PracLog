import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/data_exporter.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/utils/show_snackbar.dart';
import 'package:praclog/ui/widgets/custom_scaffold.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import '../../helpers/datetime_helpers.dart';
import '../../helpers/null_empty_helper.dart';

class DataExportScreen extends StatefulWidget {
  const DataExportScreen({Key? key}) : super(key: key);

  @override
  State<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends State<DataExportScreen> {
  late bool _loading;
  // For the form
  late TextEditingController _exportEmailController;
  late DateTimeRange _chosenDateRange;
  final _formKey = GlobalKey<FormState>();
  late bool _exportAll;

  String get _dateRangeAsString =>
      'From ${_chosenDateRange.start.getDateOnly()} to ${_chosenDateRange.end.getDateOnly()}';

  @override
  void initState() {
    _loading = false;
    _exportEmailController = TextEditingController();
    _chosenDateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    _exportAll = false;
    super.initState();
  }

  @override
  void dispose() {
    _exportEmailController.dispose();
    super.dispose();
  }

  Future export(AuthManager authManager, bool sendToSelf) async {
    String? email = _exportEmailController.text.trim();

    // Check that user is signed in with google
    if (authManager.signedInWithGoogle == false) {
      showSnackBar(context, 'User not signed in with google');
      return;
    }

    // Validate
    if (sendToSelf == false) {
      if (!email.isNotNullOrEmpty) {
        showSnackBar(context, 'Enter email address');
        return;
      } else if (!EmailValidator.validate(email)) {
        showSnackBar(context, 'Invalid email address');
        return;
      }
    }

    // Start loading screen
    setState(() {
      _loading = true;
    });

    // Export data
    String result = await DataExporter().exportData(
      authManager,
      sendToSelf ? null : email,
      fromDate: _exportAll
          ? (authManager.accountCreationDate ?? _chosenDateRange.start)
          : _chosenDateRange.start,
      toDate: _exportAll ? DateTime.now() : _chosenDateRange.end,
    );
    // End loading screen
    setState(() {
      _loading = false;
    });

    if (mounted) {
      // Show result in snackbar
      showSnackBar(context, result);
      // Go back to Settings screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Scaffold(body: LoadingWidget())
        : CustomScaffold(
            appBarTitle: 'Export my data',
            body: Form(
              key: _formKey,
              child: Column(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
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
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
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
                  const Text('Send to:', style: kSubheading),
                  const SizedBox(height: 10.0),
                  RoundedWhiteCard(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter email address',
                      ),
                      controller: _exportEmailController,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  MainButton(
                      onPressed: () {
                        export(context.read<AuthManager>(), false);
                      },
                      text: 'Send'),
                  const SizedBox(height: 10.0),
                  MainButton(
                      onPressed: () {
                        export(context.read<AuthManager>(), true);
                      },
                      text: 'Send to myself'),
                ],
              ),
            ),
          );
  }
}
