import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:praclog/models/mid_practice_data.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/models/timer_data.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/ui/auth/auth_screen.dart';
import 'package:praclog/ui/main_screen.dart';
import 'package:praclog/ui/practice/practice_screen.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: 'dev',
    );
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(const MyApp());
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set orientation to portrait only (not landscape).
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        // To use AuthManager throughout app without initialising it each time
        Provider<AuthManager>(
          create: (_) => AuthManager(
            FirebaseAuth.instance,
            GoogleSignIn(scopes: ['https://mail.google.com/']),
          ),
        ),

        // A stream that listens to changes in authentication state (e.g. sign in, sign out)
        StreamProvider<User?>(
          create: (context) => context.read<AuthManager>().authChangeStream,
          initialData: null,
        ),

        // Keeps track of practice goals temporarily during practice sessions
        ChangeNotifierProvider(create: (context) => PracticeGoalManager()),

        // Keeps track of timer data temporarily during practice sessions
        ChangeNotifierProvider(create: (context) => TimerData.empty()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PracLog',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: CustomColors.backgroundColor,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// Displays `MainScreen` if user is signed in; otherwise displays `AuthScreen`
class AuthWrapper extends StatelessWidget {
  final int? initialIndex;
  const AuthWrapper({Key? key, this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<User?>();
    return user == null
        ? const AuthScreen()
        : MainScreenWrapper(initialIndex: initialIndex);
  }
}

// Displays PracticeScreen if the user was in middle of a practice session; otherwise displays MainScreen
class MainScreenWrapper extends StatefulWidget {
  final int? initialIndex;
  const MainScreenWrapper({super.key, this.initialIndex});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  // Sets the timer data and goal list data for the practice session
  Future setPracticeData() async {
    await context.read<TimerData>().fetchData();
    if (mounted) {
      await context.read<PracticeGoalManager>().fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          SharedPreferences sharedPreferences = snapshot.data!;
          // If user is in middle of a practice session
          if (MidPracticeData.isMidPractice(sharedPreferences)) {
            // Get midPractice data
            MidPracticeData midPracticeData =
                MidPracticeData.fetchMidPracticeData(sharedPreferences);
            // Set the TimerData then go to `PracticeScreen` with the appropriate info
            return FutureBuilder(
              future: setPracticeData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                } else {
                  return PracticeScreen(
                    pieceTitle: midPracticeData.pieceTitle,
                    pieceComposer: midPracticeData.pieceComposer,
                    pieceId: midPracticeData.pieceId,
                    restored: true,
                  );
                }
              },
            );
            // Else go to main screen
          } else {
            return MainScreen(initialIndex: widget.initialIndex);
          }
        } else {
          return const LoadingWidget();
        }
      }),
    );
  }
}
