import 'package:flutter/material.dart';
import "db.dart";
import "pages/home.dart";
import "pages/search_form.dart";
import "pages/saved_workouts.dart";
import "pages/api_key_empty_error.dart";
import "widgets/ui_scaffold.dart";

void main() async {
  await WorkoutsDB.initDb();
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
    SearchForm(),
    SavedWorkoutsPage()
  ];

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
      debugShowCheckedModeBanner: false,
      home: 
        apiKeySet 
        ? Scaffold(
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
          ))
        : APIKeyEmptyErrorPage()
    );
  }
}
