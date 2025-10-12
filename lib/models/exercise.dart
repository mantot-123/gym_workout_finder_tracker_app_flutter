import "package:hive/hive.dart";

part "exercise.g.dart"; // <== Generated model adapter file

@HiveType(typeId: 0)
class Exercise {
  @HiveField(0) 
  late String bodyPart;

  @HiveField(1) 
  late String equipment;
  
  @HiveField(2)
  late String id;

  @HiveField(3) 
  late String name;

  @HiveField(4) 
  late String target;

  @HiveField(5) 
  late List<String> secondaryMuscles;

  @HiveField(6) 
  late List<String> instructions;

  @HiveField(7) 
  late String description;

  @HiveField(8) 
  late String difficulty;

  @HiveField(9)
  late String? user;

  @HiveField(10)
  late String? docId;


  Exercise(
    {
      this.bodyPart = "",
      this.equipment = "",
      this.id = "",
      this.name = "",
      this.target = "",
      required this.secondaryMuscles,
      required this.instructions,
      this.description = "",
      this.difficulty = "",
      this.user,
      this.docId // database document ID
    }
  );

  Exercise.fromMap(Map<dynamic, dynamic> data) {
    bodyPart = data["bodyPart"];
    equipment = data["equipment"];
    id = data["id"];
    name = data["name"];
    target = data["target"];
    secondaryMuscles = data["secondaryMuscles"].cast<String>();
    instructions = data["instructions"].cast<String>();
    description = data["description"];
    difficulty = data["difficulty"];
    user = data["user"];
    docId = data["docId"]; // add a database document id - since the "id" property comes from the API
  }

  Map<dynamic, dynamic> toMap() {
    return {
      "bodyPart": bodyPart,
      "equipment": equipment,
      "id": id,
      "name": name,
      "target": target,
      "secondaryMuscles": secondaryMuscles,
      "instructions": instructions,
      "description": description,
      "difficulty": difficulty,
      "user": user,
      "docId": docId
    };
  }

  static List<Exercise> fromMapList(List<Map<dynamic, dynamic>> list) {
    List<Exercise> newList = [];
    list.forEach((item) {
      newList.add(Exercise.fromMap(item));
    });
    return newList;
  }
}