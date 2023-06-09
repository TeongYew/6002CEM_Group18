import 'package:fitness_tracker_app/calorie_counter.dart';
import 'package:fitness_tracker_app/calorie_tracker.dart';
import 'package:fitness_tracker_app/main_menu.dart';
import 'package:fitness_tracker_app/running_tracker_log.dart';
import 'package:fitness_tracker_app/running_tracker_page.dart';
import 'package:fitness_tracker_app/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RunningTrackerPage.routeName,
      routes: {
        MainMenu.routeName : (context) => MainMenu(),
        CalorieTracker.routeName: (context) => CalorieTracker(),
        CalorieCounter.routeName: (context) => CalorieCounter(),
        Settings.routeName: (context) => Settings(),
        RunningTrackerPage.routeName: (context)=> RunningTrackerPage(),
        RunningTrackerLog.routeName: (context)=> RunningTrackerLog(),
      },
      debugShowCheckedModeBanner: false,
      title: "Fitness Tracker App",
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0E2376),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF0E2376)),
        primarySwatch: Colors.blue,
      ),
      home: const MainMenu(),
    );;
  }
}




