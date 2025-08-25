import 'package:flutter/material.dart';
import "package:hive/hive.dart";

part "routine.g.dart";

@HiveType(typeId: 1)
class Routine {
    @HiveField(0)
    String name;

    @HiveField(1)
    List<String> days;

    @HiveField(2)
    TimeOfDay timeStart;

    Routine({ required this.name, required this.days, required this.timeStart });
}