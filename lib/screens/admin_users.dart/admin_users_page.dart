import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/main.dart';

class AdminUsersPage extends ConsumerWidget {
  const AdminUsersPage({super.key});

  TextStyle get style => const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = ref.watch(kAdminUsersProvider) ?? [];
    final user = ref.read(kUserProvider);
    users = users
        .where((element) => !element.isSuperAdmin || element.id != user?.id)
        .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Adminler"),
      ),
      body: users.isEmpty
          ? const Center(
              child: Text("Hiç admin yok"),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return Opacity(
                  opacity: user.authorize == true ? 1 : 0.6,
                  child: Dismissible(
                    key: Key(user.id),
                    confirmDismiss: (direction) async {
                      if (user.authorize == true &&
                          direction == DismissDirection.startToEnd) {
                        ref
                            .read(kAdminUsersProvider.notifier)
                            .updateUserAuthorize(user, false);
                      }
                      if (user.authorize == false &&
                          direction == DismissDirection.endToStart) {
                        ref
                            .read(kAdminUsersProvider.notifier)
                            .updateUserAuthorize(user, true);
                      }
                      return false;
                    },
                    background: user.authorize == true
                        ? Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Engelle", style: style),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    secondaryBackground: user.authorize == false
                        ? Container(
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
                          )
                        : const SizedBox(),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.image.isEmpty
                            ? null
                            : NetworkImage(user.image),
                        child: user.image.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(user.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 20,
                          ),
                          Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                  value: user.isSuperAdmin,
                                  onChanged: (s) {
                                    ref
                                        .read(kAdminUsersProvider.notifier)
                                        .updateUserSuperAdmin(user, s);
                                  })),
                          const Icon(
                            Icons.manage_accounts,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
