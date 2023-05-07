import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/models/game_type.dart';
import 'package:game_team_creator_admin_panel/provider/providers.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';

class GameTypesProvider extends StateNotifierProviders<List<GameType>?> {
  GameTypesProvider(Ref ref) : super(ref: ref, state: []);

  StreamSubscription? _currentGamesSubscription;

  void setGameTypes(List<GameType> gameTypes) {
    state = gameTypes;
  }

  List<GameType> get gameTypes {
    return state ?? [];
  }

  @override
  void onDispose() {
    _currentGamesSubscription?.cancel();
  }

  @override
  Future<void> onInit() async {
    _currentGamesSubscription = firestoreP.getGameTypesStream().listen((event) {
      setGameTypes(event.getDatas());
    });
  }
}
