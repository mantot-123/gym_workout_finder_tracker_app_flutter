import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/models/exercise.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:firebase_core/firebase_core.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "pages/home/home.dart";
import "pages/routines/saved_routines.dart";
import "pages/exercises/saved_exercises.dart";
import "pages/home/api_key_empty_error.dart";
import "pages/account/account_profile.dart";
import "database/interfaces/exercises_db_handler.dart";
import "database/interfaces/routines_db_handler.dart";
import "database/exercises_local_db_handler.dart";
import "database/routines_local_db_handler.dart";
import "database/exercises_cloud_db_handler.dart";
import "database/routines_cloud_db_handler.dart";
import "services/exercises_db_service.dart";
import "services/routines_db_service.dart";
import "firebase_options.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // initialises the Hive database + local database handlers
  await Hive.initFlutter();
  await ExercisesDBService.dbHandler.init();
  await RoutinesDBService.dbHandler.init();

  // detect current user session, then switches database handler 
  // + syncs local data to the cloud if it finds a logged in user
  if(FirebaseAuth.instance.currentUser != null) {
    ExercisesDBService.switchDBHandlerByLoginState();
    await ExercisesDBService.synchronise();

    RoutinesDBService.switchDBHandlerByLoginState();
    await RoutinesDBService.synchronise();
  }

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedPage = 0;
  bool apiKeySet = const String.fromEnvironment("API_KEY") != "";

  List<Widget> pages = [
    HomePage(),
    RoutinesPage(),
    SavedExercisesPage(),
    AccountProfilePage()
  ];


  @override
  void dispose() {
    ExercisesDBService.dbHandler.close();
    RoutinesDBService.dbHandler.close();
    super.dispose();
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

        dialogTheme: DialogThemeData(
          titleTextStyle: TextStyle(fontFamily: "Overused Grotesk Medium"),
          contentTextStyle: TextStyle(fontFamily: "Overused Grotesk Medium"),
        ),

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
        ),

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.lightGreen.shade800)
          )
        )
      ),

      debugShowCheckedModeBanner: false,
      home: 
        apiKeySet 
        ? Scaffold(
          body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                ExercisesDBService.switchDBHandlerByLoginState();
                RoutinesDBService.switchDBHandlerByLoginState();
              }

              return pages[selectedPage];
            }
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.grey.shade50,
            indicatorColor: Colors.lightGreen.shade100,
            selectedIndex: selectedPage,
            onDestinationSelected: changePage,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home, size: 30), label: ""),
              NavigationDestination(icon: Icon(Icons.alarm, size: 30), label: ""),
              NavigationDestination(icon: Icon(Icons.fitness_center, size: 30), label: ""),
              NavigationDestination(icon: Icon(Icons.account_circle, size: 30), label: "")
            ]
          ))
        : APIKeyEmptyErrorPage()
    );
  }
}
