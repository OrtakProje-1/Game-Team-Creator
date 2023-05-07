import 'package:flutter/material.dart';
import 'package:game_team_creator_admin_panel/screens/home_page.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';
import 'package:pinput/pinput.dart';

class CheckPasswordPage extends StatefulWidget {
  const CheckPasswordPage({super.key});

  @override
  State<CheckPasswordPage> createState() => _CheckPasswordPageState();
}

class _CheckPasswordPageState extends State<CheckPasswordPage> {
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Şifreyi Doğrulayın"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Pinput(
                autofocus: true,
                controller: passwordController,
                length: 6,
                validator: (value) {
                  return value == HiveHelper.password ? null : "Hatalı Şifre";
                },
                onChanged: (value) {
                  if (value.length == 6) {
                    if (formKey.currentState!.validate()) {
                      context.pushAndRemoveUntil(const HomePage());
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
