import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";

class AccountMenu extends StatefulWidget {
  const AccountMenu({super.key});

  @override
  State<AccountMenu> createState() => _AccountMenuState();
}

class _AccountMenuState extends State<AccountMenu> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ListView(
        children: [
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return ListTile(
                  onTap: () {
                    // todo
                  },
                  title: Text("E-mail address settings"),
                  leading: Icon(Icons.alternate_email)
                );
              }
              return SizedBox();
            }
          ),

          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return ListTile(
                  onTap: () {
                    // todo
                  },
                  title: Text("Password settings"),
                  leading: Icon(Icons.password)
                );
              }
              return SizedBox();
            }
          ),

          ListTile(
            onTap: () {
              // todo
            },
            title: Text("Clear all routines"),
            leading: Icon(Icons.delete)
          ),

          ListTile(
            onTap: () {
              // todo
            },
            title: Text("Clear all saved exercises"),
            leading: Icon(Icons.delete)
          ),
          ListTile(
            onTap: () {
              // todo
            },
            title: Text("About"),
            leading: Icon(Icons.info)
          ),
        ]
      ),
    );
  }
}