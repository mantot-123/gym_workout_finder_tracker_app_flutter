import 'package:flutter/material.dart';
import "../widgets/ui/ui_button.dart";
import "../widgets/ui/ui_input_box.dart";
import "../widgets/ui/ui_scaffold.dart";
import "../models/routine.dart";
import "../helpers/rng_str_gen.dart";
import "../routines_db_handler.dart";

class EditRoutinePage extends StatefulWidget {
  final int mode; // EDIT MODES: 0 = new routine, 1 = edit
  final Routine data;
  const EditRoutinePage({super.key, required this.mode, required this.data});

  @override
  State<EditRoutinePage> createState() => _EditRoutinePageState();
}

class _EditRoutinePageState extends State<EditRoutinePage> {
  TextEditingController nameController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  String alertMsg = "";

  @override
  void initState() {
    super.initState();

    nameController.text = widget.data.name;
    selectedTime = widget.data.timeStart;
  }

  void save() {
    Routine routine = Routine(
      id: widget.mode == 1 ? widget.data.id : RngStrGen.generator(12), // generate a new id if creating a new routine
      name: nameController.text,
      timeStart: selectedTime,
      tasks: widget.data.tasks
    );

    if(widget.mode == 0) {
      SavedRoutinesDB.addToSavedRoutines(routine);
    } else {
      SavedRoutinesDB.overwriteRoutineByID(routine); // replace an existing routine with the edited one
    }

    SavedRoutinesDB.updateSavedRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: widget.mode == 1 ? "Edit routine: ${widget.data.name}" : "New routine",
      scaffoldBody: Center(
        child: Container(
          width: 500,
          height: 300,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIInputBox(label: "Routine name...", inputController: nameController),

              SizedBox(height: 15),
              Row(
                spacing: 10.0,
                children: [
                Text("Start time: ${selectedTime.format(context)}"),
                UIButton(label: "Change time", onPressedAction: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context, 
                    initialTime: selectedTime,
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.light(
                            // border color
                            primary: Colors.lightGreen.shade700,
                            secondary: Colors.lightGreen.shade400,
                          ),
                          textTheme: TextTheme(
                            bodyLarge: TextStyle(fontSize: 18, color: Colors.black, fontFamily: "Overused Grotesk Medium"),
                            bodyMedium: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Overused Grotesk Medium"),
                            bodySmall: TextStyle(fontSize: 14, color: Colors.black, fontFamily: "Overused Grotesk Medium"),
                            displayLarge: TextStyle(fontSize: 50, color: Colors.black, fontFamily: "Overused Grotesk Medium"),
                            displayMedium: TextStyle(fontSize: 50, color: Colors.black, fontFamily: "Overused Grotesk Medium"),
                          ),
                          fontFamily: "Overused Grotesk Medium"
                        ),
                        child: child!,
                      );
                    },
                    initialEntryMode: TimePickerEntryMode.dial
                  );
                  if(newTime != null) {
                    setState(() {
                      selectedTime = newTime;
                    });
                  }
                }),
              ]),

              SizedBox(height: 50),

              Row(
                spacing: 10.0,
                children: [
                  UIButton(label: "Save changes", onPressedAction: () {
                    if(nameController.text == "") {
                      setState(() { 
                        alertMsg = "Please enter a routine name!";
                      });
                      return;
                    }

                    // TODO SAVE CHANGES
                    save();

                    Navigator.of(context).pop();
                  }),
                  
                  widget.mode == 1
                  ? ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      // TODO DELETE ROUTINE
                      SavedRoutinesDB.removeFromSavedRoutines(widget.data);
                      SavedRoutinesDB.updateSavedRoutines();
                      Navigator.pop(context);
                    },
                    child: Text("Delete routine", style: TextStyle(color: Colors.white))
                  )
                  : SizedBox()
                ],
              ),

              Text(alertMsg)
            ],
          )
        ),
      ),
    );;
  }
}