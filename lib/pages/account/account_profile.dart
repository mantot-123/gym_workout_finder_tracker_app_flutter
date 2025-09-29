import "package:gym_workout_finder_tracker_app_flutter/services/exercises_db_service.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/routines_db_service.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "../auth/login.dart";
import "../../widgets/ui/ui_scaffold.dart";

class AccountProfilePage extends StatefulWidget {
  const AccountProfilePage({super.key});

  @override
  State<AccountProfilePage> createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {

  Widget _buildNotSignedInMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Not logged in", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.account_circle, size: 60),
            SizedBox(height: 10),
            Text("You are currently not logged in to an account.\nClick the button below to log in.", textAlign: TextAlign.center),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return LoginFormPage();
                }));
              },
              child: Text("Log in")
            )
        ]
      )
    );
  }

  Widget _buildAccountPage(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: Text("Sign out")
      )
    );
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
          } else if(!snapshot.hasData) {
            ExercisesDBService.switchDBHandlerByLoginState();
            RoutinesDBService.switchDBHandlerByLoginState();
            
            return _buildNotSignedInMessage(context);
          }

          return _buildAccountPage(context);
        },)
    );
  }
}