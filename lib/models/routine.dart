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

    // @HiveField(3)
    // List<Task> tasks = [];

    Routine({ required this.id, required this.name, required this.timeStart, });
}