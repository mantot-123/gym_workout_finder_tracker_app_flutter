import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/exercises_db_service.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/routines_db_service.dart";

class AccountMenu extends StatefulWidget {
  const AccountMenu({super.key});

  @override
  State<AccountMenu> createState() => _AccountMenuState();
}

class _AccountMenuState extends State<AccountMenu> {
  // "Feature unavailable" message = this is only temporary
  void _showUnavailableMsgBox(BuildContext context) {
    showDialog( 
      context: context, 
      builder: (context) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              // border color
              primary: Colors.lightGreen.shade700,
              secondary: Colors.lightGreen.shade400,
            ),
            fontFamily: "Overused Grotesk Medium",
          ),
          child: AlertDialog(
            title: Text("Feature not available"),
            content: Container(
              height: 40,
              child: Column(
                children: [
                  Container(alignment: Alignment.center, child: Text("This feature is currently unavailable. Check back later.")),
                ],
              ),
            ),
            actions: [
              TextButton(child: Text("OK"), onPressed: () {
                Navigator.of(context).pop(); // close confirmation dialog
              })
            ],
          )
        );
      },
    );
  }

  void _showClearProgressMsgBox(BuildContext context) {
    showDialog( 
      context: context, 
      builder: (context) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              // border color
              primary: Colors.lightGreen.shade700,
              secondary: Colors.lightGreen.shade400,
            ),
            fontFamily: "Overused Grotesk Medium",
          ),
          child: AlertDialog(
            title: Text("Loading..."),
            content: Container(
              height: 30,
              child: Column(
                children: [
                  Container(alignment: Alignment.center, child: Text("Clearing data, please wait....")),
                ],
              ),
            ),
          )
        );
      },
    );
  }

  // CLEAR ROUTINES
  Future<void> _confirmClearRoutines(BuildContext context) async {
    await showDialog( 
      context: context, 
      builder: (context) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              // border color
              primary: Colors.lightGreen.shade700,
              secondary: Colors.lightGreen.shade400,
            ),
            fontFamily: "Overused Grotesk Medium",
          ),
          child: AlertDialog(
            title: Text("Clear all routines"),
            content: Container(
              height: 60,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center, 
                    child: Text("Are you sure you want to clear all of your saved routines? This action cannot be undone.")
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(child: Text("Yes"), onPressed: () async {
                _showClearProgressMsgBox(context);
                var routines = await RoutinesDBService.dbHandler.getAllRoutines();
                routines = List.from(routines);
                for(final r in routines) {
                  await RoutinesDBService.dbHandler.deleteRoutine(r);
                }
                Navigator.of(context).pop(); // close "in progress" dialog
                Navigator.of(context).pop(); // close confirmation dialog
              }),

              TextButton(child: Text("No", style: TextStyle(color: Colors.red)), onPressed: () {
                Navigator.of(context).pop(); // close confirmation dialog
              })
            ],
          )
        );
      },
    );
  }

  // CLEAR EXERCISES
  Future<void> _confirmClearExercises(BuildContext context) async {
    await showDialog( 
      context: context, 
      builder: (context) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              // border color
              primary: Colors.lightGreen.shade700,
              secondary: Colors.lightGreen.shade400,
            ),
            fontFamily: "Overused Grotesk Medium",
          ),
          child: AlertDialog(
            title: Text("Clear all exercises"),
            content: Container(
              height: 60,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center, 
                    child: Text("Are you sure you want to clear all of your saved exercises? This action cannot be undone.")
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(child: Text("Yes"), onPressed: () async {
                _showClearProgressMsgBox(context);
                var exercises = await ExercisesDBService.dbHandler.getAllExercises();
                exercises = List.from(exercises);
                for(final r in exercises) {
                  await ExercisesDBService.dbHandler.deleteExercise(r);
                }
                Navigator.of(context).pop(); // close "in progress" dialog
                Navigator.of(context).pop(); // close confirmation dialog
              }),

              TextButton(child: Text("No", style: TextStyle(color: Colors.red)), onPressed: () {
                Navigator.of(context).pop(); // close confirmation dialog
              })
            ],
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final isLoggedIn = snapshot.hasData;
          
          return ListView(
            children: [
              // Only show these menu items when logged in
              if (isLoggedIn) ...[
                ListTile(
                  onTap: () {
                    _showUnavailableMsgBox(context);
                  },
                  title: Text("E-mail address settings"),
                  leading: Icon(Icons.alternate_email)
                ),
                ListTile(
                  onTap: () {
                    _showUnavailableMsgBox(context);
                  },
                  title: Text("Password settings"),
                  leading: Icon(Icons.password)
                ),
              ],

              ListTile(
                onTap: () async {
                  await _confirmClearRoutines(context);
                },
                title: Text("Clear all routines"),
                leading: Icon(Icons.delete)
              ),

              ListTile(
                onTap: () async {
                  await _confirmClearExercises(context);
                },
                title: Text("Clear all saved exercises"),
                leading: Icon(Icons.delete)
              ),
            ]
          );
        }
      ),
    );
  }
}