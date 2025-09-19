import 'package:flutter/material.dart';
import "package:http/http.dart";
import "../../widgets/ui/ui_button.dart";
import "../../widgets/ui/ui_input_box.dart";
import "../../widgets/ui/ui_scaffold.dart";
import "../../models/routine.dart";
import "../../helpers/rng_str_gen.dart";
import "../../routines_db_handler.dart";

class EditRoutinePage extends StatefulWidget {
  final int mode; // EDIT MODES: 0 = new routine, 1 = edit
  final Routine data;
  const EditRoutinePage({super.key, required this.mode, required this.data});

  @override
  State<EditRoutinePage> createState() => _EditRoutinePageState();
}

class _EditRoutinePageState extends State<EditRoutinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  String alertMsg = "";

  @override
  void initState() {
    super.initState();

    nameController.text = widget.data.name;
    selectedTime = widget.data.timeStart;
  }


  String? checkName(String? value) {
    if(value == "") {
      return "Please enter a name for your routine";
    }
    return null;
  }

  void saveChanges() {
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


  void deleteRoutine() {
    // TODO DELETE ROUTINE
    SavedRoutinesDB.removeFromSavedRoutines(widget.data);
    SavedRoutinesDB.updateSavedRoutines();
  }


  void onSaveBtnPressed() {
    bool isValid = _formKey.currentState!.validate();
    // TODO SAVE CHANGES
    if(isValid) {
      saveChanges();
      Navigator.of(context).pop();
    }
  }


  void onDeleteBtnPressed() {
    deleteRoutine();
    Navigator.pop(context);
  }


  Future<TimeOfDay?> _buildTimePicker(BuildContext context) {
    return showTimePicker(
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
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(label: Text("Routine name...")), 
            controller: nameController,
            validator: checkName
          ),
      
          SizedBox(height: 15),
      
          Row(
            spacing: 10.0,
            children: [
            Text("Start time: ${selectedTime.format(context)}"),
            UIButton(label: "Change time", onPressed: () async {
              TimeOfDay? newTime = await _buildTimePicker(context);
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
              UIButton(label: "Save changes", onPressed: onSaveBtnPressed),
              
              widget.mode == 1
              ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red.shade200),
                  elevation: WidgetStatePropertyAll(0.0)
                ),
                onPressed: onDeleteBtnPressed,
                child: Text("Delete routine", style: TextStyle(color: Colors.black87))
              )
              : SizedBox()
            ],
          ),
      
          Text(alertMsg)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: widget.mode == 1 ? "Edit routine: ${widget.data.name}" : "New routine",
      body: Center(
        child: Container(
          width: 500,
          height: 300,
          padding: EdgeInsets.all(20),
          child: _buildForm(context)
        ),
      ),
    );;
  }
}