// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkAdapter extends TypeAdapter<Bookmark> {
  @override
  final int typeId = 0;

  @override
  Bookmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bookmark(
      title: fields[0] as String,
      url: fields[1] as String,
      imageurl: fields[2] as String,
      summary: fields[3] as String,
      newsSite: fields[4] as String,
      publishedAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Bookmark obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.imageurl)
      ..writeByte(3)
      ..write(obj.summary)
      ..writeByte(4)
      ..write(obj.newsSite)
      ..writeByte(5)
      ..write(obj.publishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
