// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:game_team_creator_admin_panel/models/game.dart';
import 'package:game_team_creator_admin_panel/models/rank.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';

class GameProfile {
  int gameId;
  int rankId;
  int level;
  String nickName;
  GameProfile({
    required this.gameId,
    required this.rankId,
    required this.level,
    required this.nickName,
  });

  GameProfile copyWith({
    int? gameId,
    int? rankId,
    int? level,
    String? nickName,
  }) {
    return GameProfile(
      gameId: gameId ?? this.gameId,
      rankId: rankId ?? this.rankId,
      level: level ?? this.level,
      nickName: nickName ?? this.nickName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gameId': gameId,
      'rankId': rankId,
      'level': level,
      'nickName': nickName,
    };
  }

  factory GameProfile.fromMap(Map<String, dynamic> map) {
    return GameProfile(
      gameId: map['gameId'] as int,
      rankId: map['rankId'] as int,
      level: map['level'] as int,
      nickName: map['nickName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameProfile.fromJson(String source) =>
      GameProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserGameProfile(gameId: $gameId, rankId: $rankId, level: $level, nickName: $nickName)';
  }

  @override
  bool operator ==(covariant GameProfile other) {
    if (identical(this, other)) return true;

    return other.gameId == gameId &&
        other.rankId == rankId &&
        other.level == level &&
        other.nickName == nickName;
  }

  @override
  int get hashCode {
    return gameId.hashCode ^
        rankId.hashCode ^
        level.hashCode ^
        nickName.hashCode;
  }

  Game? get game {
    var container = ProviderHelper.getContainer();
    if (container == null) return null;
    var games = container.read(kGamesProvider);
    try {
      return games!.firstWhere((element) => element.id == gameId);
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Rank? get rank {
    try {
      var game = this.game;
      if (game != null) {
        return game.rankes.firstWhere((element) => element.id == rankId);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
