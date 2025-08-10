import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/pages/saved_workouts.dart";
import "pages/home.dart";
import "pages/search_form.dart";
import "pages/saved_workouts.dart";

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedPage = 0; 
  List<Widget> pages = [
    HomePage(),
    SearchForm(),
    SavedWorkoutsPage()
  ];


  void changePage(int newPage) {
    setState(() {
      selectedPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pages[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightGreen[200],
          selectedItemColor: Colors.lightGreen[900],
          currentIndex: selectedPage,
          onTap: changePage,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved")
          ]
        )
      ),
    );
  }
}
