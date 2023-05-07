import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:game_team_creator_admin_panel/models/game.dart';
import 'package:game_team_creator_admin_panel/models/game_type.dart';
import 'package:game_team_creator_admin_panel/models/rank.dart';
import 'package:game_team_creator_admin_panel/models/role.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/widgets/rank_widget.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/widgets/role_widget.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/widgets/text_field.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';

class CreateGame extends StatefulWidget {
  final Game? game;
  const CreateGame({super.key, this.game});

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  TextEditingController name = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController website = TextEditingController();
  List<Rank> rankes = [];
  List<Role> roles = [];
  List<GameType> selectedTypes = [];

  List<GameType> types = [];

  bool get isUpdate => widget.game != null;
  Game? get game => widget.game;

  @override
  void initState() {
    final container = ProviderHelper.getContainer();
    if (container != null) {
      types = container.read(kGameTypesProvider.notifier).gameTypes;
    }

    if (game != null) {
      name.text = game!.name;
      image.text = game!.image;
      website.text = game!.website;
      roles = game!.roles;
      rankes = game!.rankes;
      selectedTypes = game!.types;
    }
    super.initState();
  }

  void removeRank(Rank rank) {
    rankes.remove(rank);
    setState(() {});
  }

  void removeRole(Role role) {
    roles.remove(role);
    setState(() {});
  }

  void saveGame() async {
    var container = ProviderHelper.getContainer();
    if (name.text.trim().isEmpty || container == null) return;
    var gamesP = container.read(kGamesProvider.notifier);

    var newGame = Game(
      id: widget.game?.id ?? gamesP.games.map((e) => e.id).reduce(max) + 1,
      name: name.text.trim(),
      image: image.text.trim(),
      website: website.text.trim(),
      typeIds: selectedTypes.map((e) => e.id).toList(),
      likedUserIds: widget.game?.likedUserIds ?? [],
      roles: roles,
      rankes: rankes,
    );
    isUpdate
        ? await gamesP.firestoreP.updateGame(newGame)
        : await gamesP.firestoreP.addGame(newGame);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? "${game!.name} Oyununu Güncelle" : "Yeni Oyun Ekle",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 6, left: 6, bottom: 84),
        child: Column(
          children: [
            CustomTextField(
              controller: name,
              placeholder: "Oyun İsmi",
            ),
            CustomTextField(
              controller: image,
              placeholder: "Oyun Resmi",
            ),
            CustomTextField(
              controller: website,
              placeholder: "Website",
            ),
            SizedBox(
              width: double.maxFinite,
              child: Card(
                child: Column(
                  children: [
                    Text(
                      "Oyun Tipleri",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    10.height,
                    Wrap(
                      spacing: 10,
                      runSpacing: 0,
                      children: types.map((e) {
                        return ChoiceChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          selected: selectedTypes
                              .any((element) => element.id == e.id),
                          onSelected: (v) {
                            if (v) {
                              selectedTypes.add(e);
                            } else {
                              selectedTypes.remove(e);
                            }
                            setState(() {});
                          },
                          label: Text(e.name),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  child: Column(
                    children: [
                      Text(
                        "Ranklar",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      ...rankes.map((r) {
                        return RankWidget(
                          rank: r,
                          onDelete: removeRank,
                        );
                      }).toList(),
                      10.height,
                      FloatingActionButton(
                        heroTag: "hero3",
                        elevation: 0,
                        onPressed: () {
                          rankes.add(
                              Rank(id: rankes.length + 1, name: "", image: ""));
                          setState(() {});
                        },
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  child: Column(
                    children: [
                      Text(
                        "Roller",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      ...roles.map((r) {
                        return RoleWidget(
                          role: r,
                          onDelete: removeRole,
                        );
                      }).toList(),
                      10.height,
                      FloatingActionButton(
                        heroTag: "hero1",
                        elevation: 0,
                        onPressed: () {
                          roles.add(Role(
                              description: "", id: roles.length + 1, name: ""));
                          setState(() {});
                        },
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "hero2",
        onPressed: saveGame,
        label: Text(isUpdate ? "Güncelle" : "Kaydet"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
