import "package:hive/hive.dart";

part "task.g.dart";

@HiveType(typeId: 2)
class Task {
    @HiveField(0)
    String name;

    @HiveField(1)
    int restTimeSeconds;

    @HiveField(2)
    int reps;

    @HiveField(3)
    int sets;

    Task({ required this.name, required this.restTimeSeconds, required this.reps, required this.sets });
}