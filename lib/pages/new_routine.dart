import 'package:flutter/material.dart';
import "../widgets/ui/ui_button.dart";
import "../widgets/ui/ui_input_box.dart";
import "../widgets/ui/ui_scaffold.dart";
import "../models/routine.dart";
import "../helpers/rng_str_gen.dart";
import "../saved_workouts_db.dart";
import "../saved_routines_db.dart";

class NewRoutinePage extends StatefulWidget {
  const NewRoutinePage({super.key});

  @override
  State<NewRoutinePage> createState() => _NewRoutinePageState();
}

class _NewRoutinePageState extends State<NewRoutinePage> {
  TextEditingController nameController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  String alertMsg = "";

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "New routine",
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

              // create button
              UIButton(label: "Create routine", onPressedAction: () {
                if(nameController.text == "") {
                  setState(() { 
                    alertMsg = "Please enter a routine name!";
                  });
                  return;
                }

                // add to database
                Routine routine = Routine(
                  id: RngStrGen.generator(12),
                  name: nameController.text,
                  timeStart: selectedTime,
                );
                SavedRoutinesDB.addToSavedRoutines(routine);
                SavedRoutinesDB.updateSavedRoutines();

                Navigator.of(context).pop();
              }),

              Text(alertMsg)
            ],
          )
        ),
      ) 
    );;
  }
}