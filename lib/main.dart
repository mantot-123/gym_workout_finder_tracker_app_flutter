import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/models/exercise.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "pages/home.dart";
import "pages/saved_routines.dart";
import "pages/saved_workouts.dart";
import "pages/api_key_empty_error.dart";
import "exercises_db_handler.dart";
import "routines_db_handler.dart";

void main() async {
  // initialises the database 
  await Hive.initFlutter();
  
  await SavedExercisesDB.initDb();
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
    SavedExercisesPage()
  ];

  @override
  void dispose() {
    SavedExercisesDB.closeConn();
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
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade50
        ),
    
        fontFamily: "Overused Grotesk Medium",
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightGreen.shade200))
        ),
        
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.lightGreen.shade700,
          selectionHandleColor: Colors.lightGreen.shade700
        ),

        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.lightGreen.shade700),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightGreen.shade900)),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: WidgetStatePropertyAll(0.0),
            backgroundColor: WidgetStatePropertyAll(Colors.lightGreen.shade300),
            foregroundColor: WidgetStatePropertyAll(Colors.black87),
            textStyle: WidgetStatePropertyAll(TextStyle(fontFamily: "Overused Grotesk Medium"))
          )
        )
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
              NavigationDestination(icon: Icon(Icons.fitness_center, size: 30), label: "")
            ]
          ))
        : APIKeyEmptyErrorPage()
    );
  }
}
