import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:game_team_creator_admin_panel/models/game.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/create_game.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class GameCard extends ConsumerWidget {
  const GameCard({super.key, required this.game});
  final Game game;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.read(kUserProvider);
    return Card(
      color: Colors.grey.shade50,
      elevation: 6,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (game.image != "")
                  Image.network(
                    game.image,
                    fit: BoxFit.cover,
                    width: 60,
                  ),
                10.width,
                Text(
                  game.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (game.rankes.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Ranklar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: game.rankes.map((e) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    e.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (game.roles.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Roller",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: game.roles.map((e) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    e.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Oyun Tipleri",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: game.types.map((e) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    e.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SelectableText(
                game.website,
                onTap: () async {
                  await launchUrl(Uri.parse(game.website));
                },
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            if (user?.isSuperAdmin ?? false)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.push(CreateGame(
                          game: game,
                        ));
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Düzenle"),
                    ),
                  ),
                  10.width,
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.red.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        var container =
                            ProviderScope.containerOf(context, listen: false);
                        container
                            .read(kGamesProvider.notifier)
                            .firestoreP
                            .removeGame(game);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Sil"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
