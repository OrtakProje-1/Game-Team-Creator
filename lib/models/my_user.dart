// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:game_team_creator_admin_panel/models/user_game_profile.dart';

class MyUser {
  String image;
  String email;
  String name;
  String id;
  List<GameProfile> games;
  String? description;
  String? token;

  MyUser({
    required this.image,
    required this.email,
    required this.name,
    required this.id,
    required this.games,
    this.description,
    this.token,
  });

  MyUser copyWith({
    String? image,
    String? email,
    String? name,
    String? id,
    List<GameProfile>? games,
    String? description,
    String? token,
  }) {
    return MyUser(
      image: image ?? this.image,
      email: email ?? this.email,
      name: name ?? this.name,
      id: id ?? this.id,
      games: games ?? this.games,
      description: description ?? this.description,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'email': email,
      'name': name,
      'id': id,
      'games': games.map((x) => x.toMap()).toList(),
      'description': description,
      'token': token,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      image: map['image'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      id: map['id'] as String,
      games: List<GameProfile>.from(
        ((map['games'] ?? []) as List<dynamic>).map<GameProfile>(
          (x) => GameProfile.fromMap(x as Map<String, dynamic>),
        ),
      ),
      description:
          map['description'] != null ? map['description'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) =>
      MyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyUser(image: $image, email: $email, name: $name, id: $id, games: $games, description: $description, token: $token)';
  }

  @override
  bool operator ==(covariant MyUser other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.email == email &&
        other.name == name &&
        other.id == id &&
        listEquals(other.games, games) &&
        other.description == description &&
        other.token == token;
  }

  @override
  int get hashCode {
    return image.hashCode ^
        email.hashCode ^
        name.hashCode ^
        id.hashCode ^
        games.hashCode ^
        description.hashCode ^
        token.hashCode;
  }
}
