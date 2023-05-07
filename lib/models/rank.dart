// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Rank {
  int id;
  String name;
  String image;
  Rank({
    required this.id,
    required this.name,
    required this.image,
  });

  Rank copyWith({
    int? id,
    String? name,
    String? image,
  }) {
    return Rank(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory Rank.fromMap(Map<String, dynamic> map) {
    return Rank(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rank.fromJson(String source) =>
      Rank.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Rank(id: $id, name: $name, image: $image)';

  @override
  bool operator ==(covariant Rank other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.image == image;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ image.hashCode;
}
