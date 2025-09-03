import 'package:flutter/material.dart';
import "package:hive/hive.dart";
import "task.dart";

part "routine.g.dart";

@HiveType(typeId: 1)
class Routine {
    @HiveField(0)
    String id;

    @HiveField(1)
    String name;

    @HiveField(2)
    TimeOfDay timeStart;

    @HiveField(3)
    List<Task> tasks;

    Routine({ required this.id, required this.name, required this.timeStart, required this.tasks });

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