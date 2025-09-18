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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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


  Widget _buildSavedExercisesImportWindow(BuildContext context, Function setState) {
    return UIScaffold(
      appBarTitle: "Import existing exercise",
      body: SavedExercisesList(
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(label: Text("Exercise name...")), 
              controller: nameController,
              validator: (value) => value == "" ? "Exercise name must not be empty" : null
            ),
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
        
            TextFormField(
              decoration: InputDecoration(label: Text("Rest time (seconds)...")), 
              controller: restTimeController,
              validator: (value) {
                return value == "" ? "Rest time cannot be empty" 
                  : int.tryParse(value!) == null ? "Rest time must be a whole number"
                  : int.parse(value) < 0 ? "Rest time must be positive"
                  : null;
              }
            ),
            SizedBox(height: 10),
        
            TextFormField(
              decoration: InputDecoration(label: Text("Sets...")), 
              controller: setsController,
              validator: (value) {
                return value == "" ? "Number of sets cannot be empty" 
                  : int.tryParse(value!) == null ? "Number of sets must be a whole number"
                  : int.parse(value) <= 0 ? "Number of sets must be bigger than 0"
                  : null;
              }
            ),
            SizedBox(height: 10),
        
            TextFormField(
              decoration: InputDecoration(label: Text("Reps...")), 
              controller: repsController,
              validator: (value) {
                return value == "" ? "Number of reps cannot be empty" 
                  : int.tryParse(value!) == null ? "Number of reps must be a whole number"
                  : int.parse(value) <= 0 ? "Number of reps must be bigger than 0"
                  : null;
              }
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // SAVE, CANCEL AND DELETE ACTION BUTTONS
  List<Widget> _buildActionBtns(BuildContext context) {
    return [
      TextButton(child: Text("Save"), onPressed: () {
        // if there are errors in the form, show error dialog
        bool isValid = _formKey.currentState!.validate();

        if(isValid) { // saves + exits
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