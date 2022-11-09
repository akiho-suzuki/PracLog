import 'dart:io';
import 'package:csv/csv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/log.dart';
import 'package:praclog/services/auth_manager.dart';
import '../helpers/null_empty_helper.dart';
import 'package:praclog/services/database/log_database.dart';

class DataExporter {
  static const String logsData = 'logsData';
  static const String goalsData = 'goalsData';

  final List<String> _logCsvHeaders = [
    Label.logId,
    Label.date,
    Label.pieceId,
    Label.composer,
    Label.title,
    Label.movementIndex,
    Label.movementTitle,
    Label.durationInMin,
    Label.satisfaction,
    Label.progress,
    Label.focus,
    Label.notes,
  ];

  final List<String> _goalCsvHeaders = [
    Label.logId,
    'goal_text',
    'ticked',
  ];

  /// If email address is `null`, it is sent to self
  ///
  /// The result (success or error) is returned as a string
  Future<String> exportData(AuthManager authManager, String? emailAddress,
      {required DateTime fromDate, required DateTime toDate}) async {
    // Fetch all the logs between specified dates
    List<Log>? logs =
        await LogDatabase(logCollection: authManager.userLogCollection)
            .getAllLogsBetween(fromDate, toDate);

    // Return false if there are not logs found
    if (logs == null || logs.isEmpty) {
      return 'No logs found for specified dates';
    }

    // Turn the logs into Lists
    Map<String, List<List>> result = Log.convertToDatalistList(logs);
    List<List> logsDataList = result[logsData]!;
    List<List> goalsDataList = result[goalsData]!;

    // Turn log data into CSV and write as file
    String logsCsvData = _convertToCsv(logsDataList);
    String logsDataFilePath = await _getFilePath(fromDate, toDate);
    File logsFile = await _writeData(logsCsvData, logsDataFilePath);

    // Turn goal data into CSV and write as file (if there is any)
    File? goalsFile;
    if (goalsDataList.isNotNullOrEmpty) {
      String goalsDataFilePath =
          await _getFilePath(fromDate, toDate, forGoals: true);
      String goalsCsvData = _convertToCsv(goalsDataList, forGoals: true);
      goalsFile = await _writeData(goalsCsvData, goalsDataFilePath);
    }

    // Get user's Google account and credentials
    await authManager.signInWithGoogle();
    GoogleSignInAccount googleAccount = authManager.googleAccount!;
    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

    // Create email
    final smtpserver =
        gmailSaslXoauth2(googleAccount.email, googleAuth.accessToken!);
    final message = Message()
      ..from = Address(googleAccount.email, googleAccount.displayName)
      ..recipients.add(emailAddress ?? googleAccount.email)
      ..subject = 'My Practice Diary data export ${DateTime.now()}'
      ..text = 'Test message'
      ..attachments = goalsFile == null
          ? [FileAttachment(logsFile)]
          : [FileAttachment(logsFile), FileAttachment(goalsFile)];

    // Send email
    try {
      await send(message, smtpserver);
      return 'Sent successfully!';
    } on MailerException catch (e) {
      return 'Error. Data not sent.';
    }
  }

  // Converts to csv (String)
  String _convertToCsv(List<List> data, {bool forGoals = false}) {
    forGoals ? data.insert(0, _goalCsvHeaders) : data.insert(0, _logCsvHeaders);
    String result = const ListToCsvConverter().convert(data);
    return result;
  }

  // Gets path to store file (with file name)
  Future<String> _getFilePath(DateTime fromDate, DateTime toDate,
      {bool forGoals = false}) async {
    final directory = await getApplicationDocumentsDirectory();
    String fileName = forGoals ? 'goals_data' : 'log_data';
    return "${directory.path}/${fileName}_${fromDate}_$toDate.csv";
  }

  // Writes to file
  Future<File> _writeData(String csvData, String filePath) async {
    // Gets the file where data will be written.
    final file = File(filePath);
    // Write data
    return file.writeAsString(csvData);
  }
}
