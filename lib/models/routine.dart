import 'package:flutter/material.dart';
import "package:hive/hive.dart";
import "task.dart";

part "routine.g.dart";

@HiveType(typeId: 1)
class Routine {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String timeStart;

  @HiveField(3)
  late List<Task> tasks;

  @HiveField(4)
  late String? user;
  
  Routine({ required this.id, required this.name, required this.timeStart, required this.tasks, this.user });

  Routine.fromMap(Map<dynamic, dynamic> data) {
    id = data["id"];
    name = data["name"];
    timeStart = data["timeStart"];
    tasks = [];
    
    if((data["tasks"] as List).isNotEmpty) {
      for(var t in data["tasks"]) {
        tasks.add(Task(
          id: t["id"],
          name: t["name"],
          restTimeSeconds: t["restTimeSeconds"],
          reps: t["reps"],
          sets: t["sets"]
        ));
      }
    }

    user = data["user"];
  }

  Map<dynamic, dynamic> toMap() {
    List<Map<dynamic, dynamic>> tasksMap = [];
    for(var t in tasks) {
      tasksMap.add(t.toMap());
    }

    return {
      "id": id,
      "name": name,
      "timeStart": timeStart.toString(),
      "tasks": tasksMap,
      "user": user,
    };
  }

  // replace a task in task list if the given ID exists
  void taskListReplaceItem(Task task) {
    for(int i = 0; i < tasks.length; i++) {
      if(tasks[i].id == task.id) {
        tasks[i] = task;
        return;
      }
    }
  }

  void deleteTaskByID(Task task) {
    for(int i = 0; i < tasks.length; i++) {
      if(tasks[i].id == task.id) {
        tasks.removeAt(i);
        return;
      }        
    }
  }

}