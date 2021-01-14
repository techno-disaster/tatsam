// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryAdapter extends TypeAdapter<Country> {
  @override
  final int typeId = 0;

  @override
  Country read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Country(
      countryCode: fields[0] as String,
      countryName: fields[1] as String,
      region: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Country obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.countryCode)
      ..writeByte(1)
      ..write(obj.countryName)
      ..writeByte(2)
      ..write(obj.region);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
