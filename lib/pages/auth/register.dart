import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "register_success.dart";

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isFormLoading = false;
  final _registerKey = GlobalKey<FormState>(); // global key used to access and track the state of the form widget (submitting, validating data etc.)

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  String? checkEmail(String? value) {
    if(emailController.text == "") {
      return "E-mail address must not be blank";
    }

    return null;
  }

  String? checkPassword(String? value) {
    // password fields should be filled
    if(passwordController.text == "" || confirmController.text == "") {
      return "Passwords must not be blank.";
    }

    // password length check
    if(passwordController.text.length < 6) {
      return "Passwords must be at least 6 characters long";
    }

    // both passwords and confirm passwords identical
    if(passwordController.text != confirmController.text) {
      return "Both password and confirm password must match";
    }
    
    return null;
  }

  Future<void> registerBtnPressed() async {
    bool isValid = _registerKey.currentState!.validate(); // call the validator methods inside the form widgets

    if(isValid) {
      setState(() { isFormLoading = true; });
      int register = await createUser();
      setState(() { isFormLoading = false; });
      
      if(register == 0) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegisterSuccess();
        }));
      }

    }
  }

  Future<int> createUser() async {
    try {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
      ).then((credential) {
        debugPrint("Account successfully registered");
        debugPrint(credential.toString());
        debugPrint("User ID: ${credential.user!.uid}");
        debugPrint("E-mail address: ${credential.user!.email}");

        FirebaseAuth.instance.signOut();
      });

      return 0;

    } on FirebaseAuthException catch(ex) {
      _showErrorMsgDialog(ex);
      print(ex);
    
    } catch(ex) {
      print(ex);
    }

    return -1;
  }

  void _showErrorMsgDialog(FirebaseAuthException ex) {
    late String description;
    // set error message description based on error code
    if(ex.code == "email-already-in-use") { 
      description = "The e-mail address you entered is already in use. Try a different one."; 
    }
    else if(ex.code == "invalid-email") { 
      description = "The e-mail address you entered is invalid. Please enter a valid one.";
    }
    else if(ex.code == "network-request-failed") { 
      description = "An error occurred while attempting to create an account. Check your internet connection and try again";
    }
    else if(ex.code == "too-many-requests") { 
      description = "Unable to sign up. The server is handling too many requests this time. Please try again later."; 
    } 
    else {
      description = "Unable to sign up for an unknown reason. Please try again later.";
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
            title: Text("Sign up failed"),
            content: Container(
              height: 40,
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
        title: Text("Sign up")
      ),
      body: Form(
        key: _registerKey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Sign up", style: TextStyle(fontSize: 40.0)),
                  Text("Create an account, save your progress", style: TextStyle(fontSize: 20.0))
                ]
              )
            ),
              
            Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(label: Text("E-mail address")),
                    controller: emailController,
                    validator: checkEmail,
                  ),
                  SizedBox(height: 10),
        
                  TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(label: Text("Password")),
                    controller: passwordController,
                    validator: checkPassword,
                  ),
                  SizedBox(height: 10),
        
                  TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(label: Text("Confirm password")),
                    controller: confirmController
                  ),
                  SizedBox(height: 10),
        
                  isFormLoading 
                  ? LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.lightGreen.shade900, size: 50
                  )
                  : ElevatedButton(
                    onPressed: registerBtnPressed,
                    child: Text("Sign up")
                  ),
        
                  Container(
                    child: TextButton(
                      child: Text("Already have an account? Log in here."), 
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    )
                  )
                ]
              ),
        
        
            ),
          ]
        ),
      )
    );
  }
}