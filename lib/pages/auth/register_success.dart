import 'package:flutter/material.dart';

class RegisterSuccess extends StatelessWidget {
  const RegisterSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Success")
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Success", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.verified_user, size: 60),
            SizedBox(height: 10),
            Text("You have successfully created your account!\nClick the button below to log in.", textAlign: TextAlign.center),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Continue..")
            )
          ],
        )
      )
    );
  }
}