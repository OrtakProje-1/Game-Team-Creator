import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/widgets/text_field.dart';

class GameTypesWidget extends ConsumerWidget {
  const GameTypesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameTypeP = ref.watch(kGameTypesProvider);
    final user = ref.read(kUserProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: (gameTypeP ?? []
                ..sort(
                  (a, b) {
                    return a.id.compareTo(b.id);
                  },
                ))
              .map((e) {
            return ListTile(
              leading: Text(e.id.toString()),
              title: Text(e.name),
              trailing: (user?.isSuperAdmin ?? false)
                  ? IconButton(
                      onPressed: () async {
                        await ref.read(firestoreProvider).removeGameType(e);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    )
                  : null,
              onTap: !(user?.isSuperAdmin ?? false)
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController(text: e.name);
                          return AlertDialog(
                            title: const Text("Oyun Tipini Güncelle"),
                            content: CustomTextField(
                              controller: controller,
                              placeholder: "Tip adı",
                            ),
                            actions: [
                              OutlinedButton(
                                  onPressed: () async {
                                    e.name = controller.text;
                                    await ref
                                        .read(firestoreProvider)
                                        .updateGameType(e);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Güncelle"))
                            ],
                          );
                        },
                      );
                    },
            );
          }).toList(),
        ),
      ),
    );
  }
}
