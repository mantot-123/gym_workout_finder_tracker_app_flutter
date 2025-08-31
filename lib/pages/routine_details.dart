import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/widgets/ui/ui_input_box.dart";
import 'package:gym_workout_finder_tracker_app_flutter/widgets/ui/ui_scaffold.dart';
import "../models/routine.dart";
import "../models/task.dart";
import "../widgets/routine_task_table.dart";

class RoutineDetailsPage extends StatefulWidget {
  final Routine data;
  const RoutineDetailsPage({super.key, required this.data});

  @override
  State<RoutineDetailsPage> createState() => _RoutineDetailsPageState();
}

class _RoutineDetailsPageState extends State<RoutineDetailsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController restTimeController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  String nameHelperMsg = "";
  String restTimeHelperMsg = "";
  String setsHelperMsg = "";
  String repsHelperMsg = "";

  // clear form fields + helper messages
  void clearForm() {
    nameController.text = "";
    restTimeController.text = "";
    setsController.text = "";
    repsController.text = "";

    nameHelperMsg = "";
    restTimeHelperMsg = "";
    setsHelperMsg = "";
    repsHelperMsg = "";
  }

  // form validation
  bool validateForm() {
    bool isValid = true;

    nameHelperMsg = "";
    restTimeHelperMsg = "";
    setsHelperMsg = "";
    repsHelperMsg = "";

    setState(() {
      if(nameController.text == "") {
        nameHelperMsg = "Task name cannot be empty";
        isValid = false;
      }

      if(restTimeController.text == "") {
        restTimeHelperMsg = "Rest time cannot be empty";
        isValid = false;
      } else if(int.tryParse(restTimeController.text) == null) {
        restTimeHelperMsg = "Rest time must be a number";
        isValid = false;
      } else if(int.parse(restTimeController.text) < 0) {
        restTimeHelperMsg = "Rest time cannot be negative";
        isValid = false;
      }

      if(setsController.text == "") {
        setsHelperMsg = "Sets cannot be empty";
        isValid = false;
      } else if(int.tryParse(setsController.text) == null) {
        setsHelperMsg = "Sets must be a number";
        isValid = false;
      } else if(int.parse(setsController.text) <= 0) {
        setsHelperMsg = "Sets must be greater than 0";
        isValid = false;
      }

      if(repsController.text == "") {
        repsHelperMsg = "Reps cannot be empty";
        isValid = false;
      } else if(int.tryParse(repsController.text) == null) {
        repsHelperMsg = "Reps must be a number";
        isValid = false;
      } else if(int.parse(repsController.text) <= 0) {
        repsHelperMsg = "Reps must be greater than 0";
        isValid = false;
      }      
    });

    return isValid;
  }


  // edit task dialog function
  void showEditTaskDialog() {
    showDialog(// EDIT TASK DIALOG
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
            title: Text("Edit task"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UIInputBox(label: "Task name...", inputController: nameController),
                SizedBox(height: 10),

                UIInputBox(label: "Rest time (seconds)...", inputController: restTimeController, inputType: 1),
                SizedBox(height: 10),

                UIInputBox(label: "Sets...", inputController: setsController, inputType: 1),
                SizedBox(height: 10),

                UIInputBox(label: "Reps...", inputController: repsController, inputType: 1),
                SizedBox(height: 20),
              ],
            ),
            actions: [
              TextButton(child: Text("Save"), onPressed: () {
                if(!validateForm()) {
                  showDialog( // ERROR DIALOG
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
                          title: Text("Errors"),
                          content: Container(
                            height: 150,
                            child: Center(
                              child: Column(
                                children: [
                                  Text("There are errors in the form. Please fix them before saving."),
                                  SizedBox(height: 20),
                                  Text(nameHelperMsg, style: TextStyle(color: Colors.red)),
                                  Text(restTimeHelperMsg, style: TextStyle(color: Colors.red)),
                                  Text(setsHelperMsg, style: TextStyle(color: Colors.red)),
                                  Text(repsHelperMsg, style: TextStyle(color: Colors.red)),
                                ],
                              ),
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
              }),

              TextButton(child: Text("Cancel"), onPressed: () { 
                clearForm();
                Navigator.of(context).pop(); 
              })
            ],
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: widget.data.name, 
      scaffoldBody: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.all(20),
            child: Text("Start time: ${widget.data.timeStart.format(context)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(child: ListView(
            children: [
              RoutineTaskTable(data: [])
            ]),
          )
        ],
      ),
      bottomActionBtn: FloatingActionButton(
        backgroundColor: Colors.lightGreen.shade400,
        child: Icon(Icons.add_task, color: Colors.black), 
        onPressed: showEditTaskDialog
      )
    );
  }
}