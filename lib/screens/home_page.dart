import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:game_team_creator_admin_panel/models/game_type.dart';
import 'package:game_team_creator_admin_panel/screens/admin_users.dart/admin_users_page.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/create_game.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/widgets/text_field.dart';
import 'package:game_team_creator_admin_panel/screens/create_gametype/create_gametype.dart';
import 'package:game_team_creator_admin_panel/screens/user_request/user_request.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';
import 'package:game_team_creator_admin_panel/widgets/game_card.dart';

final kSelectedIndexProvider = StateProvider((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static String token =
      "cBCoIpovT6WF03_mB4HDYK:APA91bFi4Jnq3MoxCuyvW1s1-gqz1QHjUdXcoSKrUGbtDGakTgvilL6MxrWeUcEwZyyEgHrCJF28xcrposrqf6M8snP8uDNVInRbFrqkP_pV0lhEkPE0NgPITwaV7Stw3lAcqes_omwL";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(kUserRequestProvider);
    ref.read(kAdminUsersProvider);
    final gamesP = ref.watch(kGamesProvider) ?? [];
    final gamesTypeP = ref.watch(kGameTypesProvider) ?? [];
    final selectedIndexP = ref.watch(kSelectedIndexProvider);
    final user = ref.read(kUserProvider);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Ana sayfa",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(kAuthProvider).signOut();
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
          if (user?.isSuperAdmin == true)
            IconButton(
              onPressed: () {
                context.push(const AdminUsersPage());
              },
              icon: const Icon(
                Icons.manage_accounts_outlined,
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndexP,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(right: 12, left: 12, bottom: 85),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...gamesP.map((e) {
                  return GameCard(game: e);
                }).toList(),
              ],
            ),
          ),
          const GameTypesWidget(),
          const UserRequestsPage()
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndexP,
        onDestinationSelected: (value) {
          ref.read(kSelectedIndexProvider.notifier).state = value;
        },
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.games), label: "Oyunlar"),
          const NavigationDestination(
              icon: Icon(Icons.info_outline), label: "Tipler"),
          if (user?.isSuperAdmin ?? false)
            const NavigationDestination(
                icon: Icon(Icons.person_add_alt_1), label: "İstekler"),
        ],
      ),
      floatingActionButton: selectedIndexP == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                if (selectedIndexP == 0) {
                  context.push(const CreateGame());
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController controller =
                          TextEditingController();
                      return AlertDialog(
                        title: Text("Oyun Tipi Ekle"),
                        content: CustomTextField(
                          controller: controller,
                          placeholder: "Tip adı",
                        ),
                        actions: [
                          OutlinedButton(
                              onPressed: () async {
                                GameType gameType = GameType(
                                    id: gamesTypeP
                                            .map((e) => e.id)
                                            .reduce(max) +
                                        1,
                                    name: controller.text);
                                await ref
                                    .read(firestoreProvider)
                                    .addGameType(gameType);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Kaydet"))
                        ],
                      );
                    },
                  );
                }
              },
              label: Text(selectedIndexP == 0 ? "Oyun Ekle" : "Oyun Tipi Ekle"),
            ),
    );
  }
}
