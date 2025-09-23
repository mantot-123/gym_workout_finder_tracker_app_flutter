import "../../models/routine.dart";

abstract class RoutinesDBHandler {
  Future<void> init();
  Future<void> loadRoutines();
  Routine? getRoutineByID(String id);
  Future<List<Routine>> getAllRoutines();
  Future<void> addRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine);
  Future<void> deleteRoutine(Routine routine);
  Future<void> updateDB();
}