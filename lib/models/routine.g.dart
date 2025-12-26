// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineAdapter extends TypeAdapter<Routine> {
  @override
  final int typeId = 1;

  @override
  Routine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Routine(
      id: fields[11] as String,
      name: fields[12] as String,
      timeStart: fields[13] as String,
      tasks: (fields[14] as List).cast<Task>(),
      user: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Routine obj) {
    writer
      ..writeByte(5)
      ..writeByte(11)
      ..write(obj.id)
      ..writeByte(12)
      ..write(obj.name)
      ..writeByte(13)
      ..write(obj.timeStart)
      ..writeByte(14)
      ..write(obj.tasks)
      ..writeByte(15)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
