import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/models/workout.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "pages/home.dart";
import "pages/saved_routines.dart";
import "pages/search_form.dart";
import "pages/saved_workouts.dart";
import "pages/api_key_empty_error.dart";
import "widgets/ui/ui_scaffold.dart";
import "workouts_db_handler.dart";
import "routines_db_handler.dart";

void main() async {
  // initialises the database 
  await Hive.initFlutter();
  
  await SavedWorkoutsDB.initDb();
  await SavedRoutinesDB.initDb();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedPage = 0;
  bool apiKeySet = false;

  List<Widget> pages = [
    HomePage(),
    RoutinesPage(),
    SearchForm(),
    SavedWorkoutsPage()
  ];

  @override
  void dispose() {
    SavedWorkoutsDB.closeConn();
    SavedRoutinesDB.closeConn();
    super.dispose();
  }

  @override
  void initState() {
    // check if an API key is set before running
    final String API_KEY = const String.fromEnvironment("API_KEY");
    if(API_KEY != "") {
      apiKeySet = true;
    }
  }

  void changePage(int newPage) {
    setState(() {
      selectedPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Overused Grotesk Medium",
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen.shade200))
        )
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.lightGreen.shade700,
        //     foregroundColor: Colors.white
        //   )
        // )
      ),
      debugShowCheckedModeBanner: false,
      home: 
        apiKeySet 
        ? Scaffold(
          body: pages[selectedPage],
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.grey.shade50,
            indicatorColor: Colors.lightGreen.shade100,
            selectedIndex: selectedPage,
            onDestinationSelected: changePage,
            height: 30,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home, size: 30), label: ""),
              NavigationDestination(icon: Icon(Icons.alarm, size: 30), label: ""),
              NavigationDestination(icon: Icon(Icons.search, size: 30), label: ""),
              NavigationDestination(icon: Icon(Icons.bookmark, size: 30), label: "")
            ]
          ))
        : APIKeyEmptyErrorPage()
    );
  }
}
