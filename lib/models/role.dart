// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Role {
  int id;
  String name;
  String description;
  Role({
    required this.id,
    required this.name,
    required this.description,
  });

  Role copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) =>
      Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Role(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(covariant Role other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
