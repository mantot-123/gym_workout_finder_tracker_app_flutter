import "package:gym_workout_finder_tracker_app_flutter/services/exercises_db_service.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/routines_db_service.dart";
import "package:gym_workout_finder_tracker_app_flutter/widgets/account/account_tile.dart";
import "package:gym_workout_finder_tracker_app_flutter/widgets/account/account_menu.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';

class AccountProfilePage extends StatefulWidget {
  const AccountProfilePage({super.key});

  @override
  State<AccountProfilePage> createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {
  bool? _previousAuthState;

  @override
  void initState() {
    super.initState();
    _previousAuthState = FirebaseAuth.instance.currentUser != null;
  }

  Future<void> _handleAuthStateChange(bool isLoggedIn) async {
    // Only switch if auth state actually changed
    if (_previousAuthState != isLoggedIn) {
      _previousAuthState = isLoggedIn;
      try {
        await ExercisesDBService.switchDBHandlerByLoginState();
        await RoutinesDBService.switchDBHandlerByLoginState();
      } catch (e) {
        print("Error switching DB handlers: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.lightGreen.shade900, size: 100
              ),
            );
          }
          
          // Handle auth state changes without side effects in builder
          if (snapshot.connectionState == ConnectionState.active) {
            final isLoggedIn = snapshot.hasData;
            _handleAuthStateChange(isLoggedIn);
          }

          return Column(
            children: [
              AccountTile(),
              AccountMenu()
            ],
          );
        },
      )
    );
  }
}