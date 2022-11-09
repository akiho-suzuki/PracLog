import 'package:flutter/material.dart';
import 'package:praclog/ui/home/home_screen.dart';
import 'package:praclog/ui/logs/log_screen.dart';
import 'package:praclog/ui/practice/pre_practice_screen.dart';
import 'package:praclog/ui/repertoire/repertoire_screen.dart';
import 'package:praclog/ui/settings/settings_screen.dart';

// Strings to display on the app bar for the main pages, in the same order as the Bottom Navigation bar items
const List<String> _appBarTitles = [
  'PracLog',
  'My repertoire',
  'My logs',
  'Settings'
];

class MainScreen extends StatefulWidget {
  final int? initialIndex;
  const MainScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _chosenIndex;

  @override
  void initState() {
    // If no initial index is provided, default to 0 (home page)
    _chosenIndex = widget.initialIndex ?? 0;
    super.initState();
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const RepertoireScreen(),
    const LogScreen(),
    const SettingsScreen(),
  ];

  List<BottomNavigationBarItem> get _bottomNavItems => const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_music), label: 'Repertoire'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Log'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_chosenIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PrePracticeScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomNavItems,
        currentIndex: _chosenIndex,
        onTap: (int index) {
          setState(() {
            _chosenIndex = index;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IndexedStack(
          index: _chosenIndex,
          children: _screens,
        ),
      ),
    );
  }
}
