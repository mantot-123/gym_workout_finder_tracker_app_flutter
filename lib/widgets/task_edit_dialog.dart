import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/widgets/ui/ui_input_box.dart";
import 'package:gym_workout_finder_tracker_app_flutter/widgets/ui/ui_scaffold.dart';
import "../models/task.dart";
import "../models/routine.dart";
import "../helpers/rng_str_gen.dart";
import "../routines_db_handler.dart";

class TaskEditDialog {
  int mode; // MODES: 0 = create new, 1 = edit
  Routine routine;
  Task task;

  TextEditingController nameController = TextEditingController();
  TextEditingController restTimeController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  String nameHelperMsg = "";
  String restTimeHelperMsg = "";
  String setsHelperMsg = "";
  String repsHelperMsg = "";

  TaskEditDialog({ required this.routine, required this.task, required this.mode }) {
    // prefill form fields with existing task data
    nameController.text = task.name;
    restTimeController.text = task.restTimeSeconds.toString();
    setsController.text = task.sets.toString();
    repsController.text = task.reps.toString();
  }
  
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

    if(nameController.text == "") {
      nameHelperMsg = "Task name cannot be empty";
      isValid = false;
    }

    if(restTimeController.text == "") {
      restTimeHelperMsg = "Rest time cannot be empty";
      isValid = false;
    } else if(int.tryParse(restTimeController.text) == null) {
      restTimeHelperMsg = "Rest time must be an integer";
      isValid = false;
    } else if(int.parse(restTimeController.text) < 0) {
      restTimeHelperMsg = "Rest time cannot be negative";
      isValid = false;
    }

    if(setsController.text == "") {
      setsHelperMsg = "Sets cannot be empty";
      isValid = false;
    } else if(int.tryParse(setsController.text) == null) {
      setsHelperMsg = "Sets must be an integer";
      isValid = false;
    } else if(int.parse(setsController.text) <= 0) {
      setsHelperMsg = "Sets must be greater than 0";
      isValid = false;
    }

    if(repsController.text == "") {
      repsHelperMsg = "Reps cannot be empty";
      isValid = false;
    } else if(int.tryParse(repsController.text) == null) {
      repsHelperMsg = "Reps must be an integer";
      isValid = false;
    } else if(int.parse(repsController.text) <= 0) {
      repsHelperMsg = "Reps must be greater than 0";
      isValid = false;
    }      

    return isValid;
  }

  void save() {
    // TODO ADD NEW TASK TO ROUTINE
    
    if(mode == 0) {
      Task newTask = Task(
        id: RngStrGen.generator(12),
        name: nameController.text, 
        restTimeSeconds: int.parse(restTimeController.text), 
        sets: int.parse(setsController.text), 
        reps: int.parse(repsController.text)
      );

      routine.tasks.add(newTask);
      SavedRoutinesDB.updateSavedRoutines();
      SavedRoutinesDB.overwrite(routine, routine); // overwrite the routine with the new task added
  
    } else if(mode == 1) {
      // TODO EDIT EXISTING TASK IN ROUTINE
    }

    SavedRoutinesDB.updateSavedRoutines(); // update the saved routines in the database
  }

  // Show edit dialog form
  Future show(BuildContext context) {
    return showDialog(// EDIT TASK DIALOG
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
            title: Text(mode == 0 ? "New exercise" : "Edit exercise"),
            content: Container(
              height: 300,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UIInputBox(label: "Exercise name...", inputController: nameController),
                  SizedBox(height: 10),
              
                  UIInputBox(label: "Rest time (seconds)...", inputController: restTimeController, inputType: 1),
                  SizedBox(height: 10),
              
                  UIInputBox(label: "Sets...", inputController: setsController, inputType: 1),
                  SizedBox(height: 10),
              
                  UIInputBox(label: "Reps...", inputController: repsController, inputType: 1),
                  SizedBox(height: 20),
                ],
              ),
            ),
            actions: [
              TextButton(child: Text("Save"), onPressed: () {
                // if there are errors in the form, show error dialog
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
                                  nameHelperMsg != "" ? Text(nameHelperMsg, style: TextStyle(color: Colors.red)) : SizedBox(),
                                  restTimeHelperMsg != "" ? Text(restTimeHelperMsg, style: TextStyle(color: Colors.red)) : SizedBox(),
                                  setsHelperMsg != "" ? Text(setsHelperMsg, style: TextStyle(color: Colors.red)) : SizedBox(),
                                  repsHelperMsg != "" ? Text(repsHelperMsg, style: TextStyle(color: Colors.red)) : SizedBox(),
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
                
                else { // saves + exits
                  save();
                  clearForm();
                  Navigator.of(context).pop(); // close edit dialog
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
}