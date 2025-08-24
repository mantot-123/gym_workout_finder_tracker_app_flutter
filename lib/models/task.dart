import "package:hive/hive.dart";

part "task.g.dart";

@HiveType(typeId: 2)
class Task {
    @HiveField(0)
    String name;

    @HiveField(1)
    int durationSeconds;

    Task({ required this.name, required this.durationSeconds });
}