import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/data_managers/logs_delete_manager.dart';
import 'package:praclog_v2/data_managers/practice_goal_manager.dart';
import 'package:praclog_v2/data_managers/timer_data_manager.dart';
import 'package:praclog_v2/ui/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open([
    PieceSchema,
    LogSchema,
  ], directory: dir.path, inspector: true);
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    // Set orientation to portrait only (not landscape).
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        // To keeps track of practice goals temporarily during practice sessions
        ChangeNotifierProvider(
          create: (context) => PracticeGoalManager(),
        ),
        // To keep track of timer data temporarily during practice sessions
        ChangeNotifierProvider(create: (context) => TimerDataManager()),
        // For deleting multiple logs
        ChangeNotifierProvider(create: (context) => LogsDeleteManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'PracLog',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: kBackgroundColor),
        home: MainScreen(isar: isar),
      ),
    );
  }
}
