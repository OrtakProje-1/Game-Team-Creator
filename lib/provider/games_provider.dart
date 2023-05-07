import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/models/game.dart';
import 'package:game_team_creator_admin_panel/provider/providers.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';

class GamesProvider extends StateNotifierProviders<List<Game>?> {
  GamesProvider(Ref ref) : super(ref: ref, state: []);

  StreamSubscription? _currentGamesSubscription;

  void setGames(List<Game> games) {
    state = games;
  }

  List<Game> get games {
    return state ?? [];
  }

  @override
  void onDispose() {
    _currentGamesSubscription?.cancel();
  }

  @override
  Future<void> onInit() async {
    _currentGamesSubscription = firestoreP.getGamesStream().listen((event) {
      setGames(event.getDatas());
    });
  }
}
