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

    @HiveField(4)
    String id;

    Task({ required this.id, required this.name, required this.restTimeSeconds, required this.reps, required this.sets });
}