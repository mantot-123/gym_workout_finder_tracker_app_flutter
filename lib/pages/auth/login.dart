import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/interfaces/exercises_db_handler.dart";
import "package:gym_workout_finder_tracker_app_flutter/models/exercise.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/exercises_db_service.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/routines_db_service.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "register.dart";

class LoginFormPage extends StatefulWidget {
  const LoginFormPage({super.key});

  @override
  State<LoginFormPage> createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  bool isFormLoading = false;
  final _loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? checkEmail(String? value) {
    return value == "" ? "E-mail address must not be blank" : null;
  }

  String? checkPassword(String? value) {
    return value == "" ? "Password must not be blank" : null;
  }

  Future<void> loginBtnPressed() async {
    bool isValid = _loginKey.currentState!.validate();

    if(isValid) {
      setState(() { isFormLoading = true; });
      final credential = await login();
      setState(() { isFormLoading = false; });

      if(credential != null) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<UserCredential?> login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );

      ExercisesDBService.switchDBHandlerByLoginState();
      RoutinesDBService.switchDBHandlerByLoginState();
      
      await ExercisesDBService.synchronise();
      await RoutinesDBService.synchronise();

      return credential;

    } on FirebaseAuthException catch(ex) {
      _showErrorMsgDialog(ex);
      print(ex);
    } catch(ex) {
      print(ex);
    }

    return null;
  }

  void _showErrorMsgDialog(FirebaseAuthException ex) {
    late String description;
    // set error message description based on error code
    if(ex.code == "invalid-email") { 
      description = "The e-mail address you entered is invalid. Please enter a valid one.";
    }
    else if(ex.code == "user-disabled") {
      description = "This account has been disabled.";
    }
    else if(ex.code == "network-request-failed") { 
      description = "An error occurred while attempting to log in. Check your internet connection and try again";
    }
    else if(ex.code == "too-many-requests") { 
      description = "Unable to log in. The server is handling too many requests this time. Please try again later."; 
    } 
    else {
      description = "Unable to log in. Please make sure that your e-mail address and password are entered correctly. Otherwise, try again later.";
    }

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
            title: Text("Log in failed"),
            content: Container(
              height: 60,
              child: Column(
                children: [
                  Container(alignment: Alignment.center, child: Text(description)),
                ],
              ),
            ),
            actions: [
              TextButton(child: Text("OK"), onPressed: () {
                Navigator.of(context).pop(); // close error dialog
              })
            ],
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in")
      ),
      body: Form(
        key: _loginKey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Welcome!", style: TextStyle(fontSize: 40.0)),
                  Text("Log in to get started!", style: TextStyle(fontSize: 20.0))
                ]
              )
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // border: BoxBorder.all(color: Colors.black87),
                  color: Colors.lightGreen.shade100,
                ),
                
                child: Row(
                  spacing: 20.0,
                  children: [
                    Icon(Icons.cloud, size: 40.0),
                    Flexible(child: Text("All of your workout routines + exercises will automatically be saved\nto the cloud once you log in", style: TextStyle(fontSize: 15.5)))
                  ]
                ),
              )
            ),
      
            Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(label: Text("E-mail address")),
                    controller: emailController,
                    validator: checkEmail
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(label: Text("Password")),
                    controller: passwordController,
                    validator: checkPassword
                  ),
                  SizedBox(height: 10),

                  isFormLoading 
                  ? LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.lightGreen.shade900, size: 50
                  )
                  : ElevatedButton(
                    onPressed: loginBtnPressed,
                    child: Text("Log in")
                  ),

                  Container(
                    child: TextButton(
                      child: Text("Don't have an account? Sign up now!"), 
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return RegisterForm();
                        }));
                      }
                    )
                  )
                ]
              ),


            ),
          ]
        )
      )
    );
  }
}