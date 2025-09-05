// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 0;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      bodyPart: fields[0] as String,
      equipment: fields[1] as String,
      id: fields[2] as String,
      name: fields[3] as String,
      target: fields[4] as String,
      secondaryMuscles: (fields[5] as List).cast<String>(),
      instructions: (fields[6] as List).cast<String>(),
      description: fields[7] as String,
      difficulty: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.bodyPart)
      ..writeByte(1)
      ..write(obj.equipment)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.target)
      ..writeByte(5)
      ..write(obj.secondaryMuscles)
      ..writeByte(6)
      ..write(obj.instructions)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
