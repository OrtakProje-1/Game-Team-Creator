import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/main.dart';

class UserRequestsPage extends ConsumerWidget {
  const UserRequestsPage({super.key});

  TextStyle get style => const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(kUserRequestProvider) ?? [];
    return Scaffold(
      body: requests.isEmpty
          ? const Center(
              child: Text("Burada Hiç İstek Yok..."),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var user = requests[index];
                return Dismissible(
                  key: Key(user.id),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await ref
                          .read(kUserRequestProvider.notifier)
                          .requestAnswer(user, false);
                    }
                    if (direction == DismissDirection.endToStart) {
                      await ref
                          .read(kUserRequestProvider.notifier)
                          .requestAnswer(user, true);
                    }
                    return true;
                  },
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Engelle",
                            style: style,
                          )
                        ],
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "İzin Ver",
                            style: style,
                          )
                        ],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          user.image.isEmpty ? null : NetworkImage(user.image),
                      child:
                          user.image.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    title: Text(user.name),
                  ),
                );
              },
            ),
    );
  }
}
