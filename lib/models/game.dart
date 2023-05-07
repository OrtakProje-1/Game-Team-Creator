// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:game_team_creator_admin_panel/models/game_type.dart';
import 'package:game_team_creator_admin_panel/models/rank.dart';
import 'package:game_team_creator_admin_panel/models/role.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';

class Game {
  int id;
  String name;
  String image;
  String website;
  List<int> typeIds;
  List<String> likedUserIds;
  List<Role> roles;
  List<Rank> rankes;
  Game({
    required this.id,
    required this.name,
    required this.image,
    required this.website,
    required this.typeIds,
    required this.likedUserIds,
    required this.roles,
    required this.rankes,
  });

  Game copyWith({
    int? id,
    String? name,
    String? image,
    String? website,
    List<int>? typeIds,
    List<String>? likedUserIds,
    List<Role>? roles,
    List<Rank>? rankes,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      website: website ?? this.website,
      typeIds: typeIds ?? this.typeIds,
      likedUserIds: likedUserIds ?? this.likedUserIds,
      roles: roles ?? this.roles,
      rankes: rankes ?? this.rankes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'website': website,
      'typeIds': typeIds,
      'likedUserIds': likedUserIds,
      'roles': roles.map((x) => x.toMap()).toList(),
      'rankes': rankes.map((x) => x.toMap()).toList(),
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      website: map['website'] as String,
      typeIds: List<int>.from((map['typeIds'] as List<dynamic>)),
      likedUserIds: List<String>.from((map['likedUserIds'] as List<dynamic>)),
      roles: List<Role>.from(
        (map['roles'] as List<dynamic>).map<Role>(
          (x) => Role.fromMap(x as Map<String, dynamic>),
        ),
      ),
      rankes: List<Rank>.from(
        (map['rankes'] as List<dynamic>).map<Rank>(
          (x) => Rank.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) =>
      Game.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Game(id: $id, name: $name, image: $image, website: $website, typeIds: $typeIds, likedUserIds: $likedUserIds, roles: $roles, rankes: $rankes)';
  }

  @override
  bool operator ==(covariant Game other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.image == image &&
        other.website == website &&
        listEquals(other.typeIds, typeIds) &&
        listEquals(other.likedUserIds, likedUserIds) &&
        listEquals(other.roles, roles) &&
        listEquals(other.rankes, rankes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        website.hashCode ^
        typeIds.hashCode ^
        likedUserIds.hashCode ^
        roles.hashCode ^
        rankes.hashCode;
  }

  List<GameType> get types {
    var container = ProviderHelper.getContainer();
    if (container == null) return [];
    var gameTypes = container.read(kGameTypesProvider.notifier).gameTypes;
    return gameTypes
        .where((element) => typeIds.any((id) => id == element.id))
        .toList();
  }
}
