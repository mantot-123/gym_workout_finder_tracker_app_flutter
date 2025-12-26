import "package:hive/hive.dart";

part "task.g.dart";

@HiveType(typeId: 2)
class Task {
  @HiveField(16)
  late String id;

  @HiveField(17)
  late String name;

  @HiveField(18)
  late int restTimeSeconds;

  @HiveField(19)
  late int reps;

  @HiveField(20)
  late int sets;

  Task({ required this.id, required this.name, required this.restTimeSeconds, required this.reps, required this.sets });

  Task.fromMap(Map<dynamic, dynamic> data) {
    id = data["id"];
    name = data["name"];
    restTimeSeconds = data["restTimeSeconds"];
    reps = data["reps"];
    sets = data["sets"];
  }

  Map<dynamic, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "restTimeSeconds": restTimeSeconds,
      "reps": reps,
      "sets": sets,
    };
  }
}