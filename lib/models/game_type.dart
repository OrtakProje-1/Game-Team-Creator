// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GameType {
  int id;
  String name;
  GameType({
    required this.id,
    required this.name,
  });

  GameType copyWith({
    int? id,
    String? name,
  }) {
    return GameType(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory GameType.fromMap(Map<String, dynamic> map) {
    return GameType(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameType.fromJson(String source) =>
      GameType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GameType(id: $id, name: $name)';

  @override
  bool operator ==(covariant GameType other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
