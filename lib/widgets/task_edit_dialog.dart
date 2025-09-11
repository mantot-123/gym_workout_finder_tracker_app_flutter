import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/widgets/ui/ui_input_box.dart";
import "../widgets/ui/ui_scaffold.dart";
import "../widgets/saved_exercises_list.dart";
import "../models/task.dart";
import "../models/routine.dart";
import "../helpers/rng_str_gen.dart";
import "../routines_db_handler.dart";
import "../exercises_db_handler.dart";

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
    Task newTask = Task(
      id: mode == 0 ? RngStrGen.generator(12) : task.id,
      name: nameController.text, 
      restTimeSeconds: int.parse(restTimeController.text), 
      sets: int.parse(setsController.text), 
      reps: int.parse(repsController.text)
    );

    if(mode == 0) {
      routine.tasks.add(newTask);
    } else if(mode == 1) {
      routine.taskListReplaceItem(newTask);
    }

    SavedRoutinesDB.updateSavedRoutines(); // update the saved routines in the database
  }


  // ERROR MESSAGE DIALOG
  void _showErrorMsgDialog(BuildContext context) {
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
            title: Text("Errors"),
            content: Container(
              height: 150,
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

  Widget _buildSavedExercisesImportWindow(BuildContext context, Function setState) {
    return UIScaffold(
      appBarTitle: "Import existing exercise",
      body: 
        SavedExercisesDB.getSavedExercises().isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Saved exercises", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.save, size: 60),
                SizedBox(height: 10),
                Text("All of your saved exercises will show here.\nTo find a new exercise,\nclick the search button on the top-right.", textAlign: TextAlign.center)
              ],
            )
          )
        : SavedExercisesList(
            actionBtnType: 2,
            actionBtnOnPressed: (task) {
              Navigator.of(context).pop(task.name);
            }
        ),
    );;
  }

  // INPUT BOXES
  Widget _buildInputBoxes(BuildContext context, Function setState) {
    return Container(
      height: 400,
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UIInputBox(label: "Exercise name...", controller: nameController),
          SizedBox(height: 10),

          ElevatedButton(
            child: Text("Choose saved exercise.."),
            onPressed: () async {
              nameController.text = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return _buildSavedExercisesImportWindow(context, setState);
                  }
                )
              );
            }
          ),
          SizedBox(height: 10),

          UIInputBox(label: "Rest time (seconds)...", controller: restTimeController, inputType: 1),
          SizedBox(height: 10),
      
          UIInputBox(label: "Sets...", controller: setsController, inputType: 1),
          SizedBox(height: 10),
      
          UIInputBox(label: "Reps...", controller: repsController, inputType: 1),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // SAVE, CANCEL AND DELETE ACTION BUTTONS
  List<Widget> _buildActionBtns(BuildContext context) {
    return [
      TextButton(child: Text("Save"), onPressed: () {
        // if there are errors in the form, show error dialog
        if(!validateForm()) {
          _showErrorMsgDialog(context);
        } 
        
        else { // saves + exits
          save();
          clearForm();
          Navigator.of(context).pop(); // close edit dialog
        }
      }),

      mode == 1 
      ? TextButton(
          child: Text("Delete", style: TextStyle(color: Colors.red)), 
          onPressed : () {
            // TODO DELETE FUNCTION
            routine.deleteTaskByID(task);
            SavedRoutinesDB.updateSavedRoutines();
            clearForm();
            Navigator.of(context).pop();
          }
        ) 
      : SizedBox(),

      TextButton(child: Text("Cancel"), onPressed: () { 
        clearForm();
        Navigator.of(context).pop(); 
      })
    ];
  }

  // Show edit dialog form
  Future show(BuildContext context) {
    return showDialog(// EDIT TASK DIALOG
      context: context, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                content: _buildInputBoxes(context, setState),
                actions: _buildActionBtns(context),
              )
            );
          }
        );
      }
    );
  }
}