import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authP = ref.read(kAuthProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Giriş Yap"),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 100,
                  ),
                  20.height,
                  OutlinedButton(
                    onPressed: () async {
                      await authP.signInWithGoogle();
                    },
                    child: const Text("Google ile Giriş Yap"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
