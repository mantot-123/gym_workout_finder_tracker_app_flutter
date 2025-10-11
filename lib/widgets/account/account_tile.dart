import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:gym_workout_finder_tracker_app_flutter/pages/auth/login.dart';

class AccountTile extends StatefulWidget {
  const AccountTile({super.key});

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  Future<bool> showConfirmLogoutDialog(BuildContext context) async {
    bool logOut = false;
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
            title: Text("Log out"),
            content: Container(
              height: 60,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center, 
                    child: Text("Are you sure you want to log out? You won't be able to access your previously saved exercises and routines until you log back in")
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(child: Text("Yes"), onPressed: () {
                logOut = true;
                Navigator.of(context).pop(); // close error dialog
              }),

              TextButton(child: Text("No", style: TextStyle(color: Colors.red)), onPressed: () {
                Navigator.of(context).pop(); // close error dialog
              })
            ],
          )
        );
      },
    );
    return logOut;
  }

  // build this if it detects a guest user
  Widget _buildNotSignedInTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_circle, size: 60),
        Text("Username here", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(FirebaseAuth.instance.currentUser?.email ?? "", textAlign: TextAlign.center),
        TextButton(
          onPressed: () async {
            if(await showConfirmLogoutDialog(context)) {
              FirebaseAuth.instance.signOut();
            }
          },
          child: Text("Log out")
        )
      ],
    );
  }

  // build this for signed in users
  Widget _buildAccountTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_circle, size: 60),
        Text("Not logged in", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text("Log in now to save data and progress", textAlign: TextAlign.center),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginFormPage();
            }));
          },
          child: Text("Log in")
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(), 
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return _buildNotSignedInTile(context);
            }
            return _buildAccountTile(context);
          }
        ),
      ),
    );
  }
}