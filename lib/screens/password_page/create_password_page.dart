import 'package:flutter/material.dart';
import 'package:game_team_creator_admin_panel/screens/home_page.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';
import 'package:pinput/pinput.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  String password1 = "";
  String password2 = "";
  bool hasCheck = false;
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(hasCheck ? "Şifreyi Tekrar Girin" : "Şifre Belirleyin"),
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
                  return value == password1 ? null : "Şifreler Eşleşmiyor";
                },
                onChanged: (value) async {
                  if (value.length == 6) {
                    if (!hasCheck) {
                      password1 = value;
                      hasCheck = true;
                      passwordController.text = "";
                      setState(() {});
                    } else {
                      if (formKey.currentState!.validate()) {
                        await HiveHelper.setPassword(value);
                        if (mounted) {
                          context.pushAndRemoveUntil(const HomePage());
                        }
                      }
                    }
                  }
                },
              ),
            ),
            if (hasCheck)
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      hasCheck = false;
                      passwordController.text = "";
                      password1 = "";
                      password2 = "";
                    });
                  },
                  child: const Text("Sıfırla")),
          ],
        ),
      ),
    );
  }
}
