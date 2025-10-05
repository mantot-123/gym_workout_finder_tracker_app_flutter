import "dart:async";
import 'package:gym_workout_finder_tracker_app_flutter/database/interfaces/exercises_db_handler.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "../../models/exercise.dart";

// TODO
class SavedExercisesCloudDB implements ExercisesDBHandler {
  static final SavedExercisesCloudDB _handler = SavedExercisesCloudDB._internal();
  late StreamSubscription<QuerySnapshot<Object?>> subscription;
  CollectionReference collection = FirebaseFirestore.instance.collection("exercises");
  List<Exercise> exercises = [];

  SavedExercisesCloudDB._internal();

  factory SavedExercisesCloudDB() => _handler; 

  @override
  Future<void> init() async {
    await loadExercises();
  }

  @override
  Future<void> loadExercises() async {
    // listens for any new exercises added and add them to the saved exercises list
    subscription = collection
      .where("user", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("creationDate")
      .snapshots().listen((snapshot) {
        exercises.clear();
        for(var document in snapshot.docs) {
          Map<dynamic, dynamic> map = document.data() as Map<dynamic, dynamic>;
          Exercise e = Exercise.fromMap(map);
          exercises.add(e);
        }
      }
    );
  }

  @override
  Future<void> close() async {
    subscription.cancel();
  }

  @override
  Future<List<Exercise>> getAllExercises() async {
    return exercises;
  }

  @override
  Future<void> addExercise(Exercise exercise) async {
    Map<String, dynamic> dataMap = exercise.toMap().cast<String, dynamic>();
    dataMap["user"] = FirebaseAuth.instance.currentUser!.uid; // add the current logged in user id
    dataMap["creationDate"] = FieldValue.serverTimestamp();

    if(dataMap["docId"] == "") {
      DocumentReference doc = await collection.add(dataMap);
      doc.update({
        "docId" : doc.id,
        "creationDate" : FieldValue.serverTimestamp() 
      });

    } else {
      // collection.add(dataMap);
      await collection.doc(dataMap["docId"]).set(dataMap); 
    }
  }

  @override
  Future<void> updateExercise(Exercise exercise) async {
    Map<String, dynamic> dataMap = exercise.toMap().cast<String, dynamic>();
    dataMap["user"] = FirebaseAuth.instance.currentUser!.uid;
    dataMap["creationDate"] = FieldValue.serverTimestamp();
    await collection.doc(dataMap["docId"]).set(dataMap);
  } // finds an exercise with a matching ID then overwrites that


  @override
  Future<void> deleteExercise(Exercise exercise) async  {
    await collection.doc(exercise.docId).delete();
  } 


  @override
  Future<void> updateDB() async { // REDUNDANT - NO NEED TO UPDATE DATABASE - FIREBASE ALREADY DOES THAT FOR YOU
    return;
  }

  @override
  bool isExerciseSaved(String id) {
    for(var e in exercises) {
      if(e.id == id) {
        return true;
      }
    }
    return false;
  }
}