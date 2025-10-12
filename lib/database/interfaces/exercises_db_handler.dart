import "../../models/exercise.dart";

abstract class ExercisesDBHandler {
  Future<void> init();
  Future<void> close();
  Future<void> loadExercises();
  Future<List<Exercise>> getAllExercises();
  Future<void> addExercise(Exercise exercise);
  Future<void> updateExercise(Exercise exercise); // finds an exercise with a matching ID then overwrites that
  Future<void> deleteExercise(Exercise exercise); // finds an exercise with a matching ID then deletes that
  Future<void> updateDB();
  bool isExerciseSaved(String id);
}