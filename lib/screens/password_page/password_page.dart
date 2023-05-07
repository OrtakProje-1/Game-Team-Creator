import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:game_team_creator_admin_panel/screens/password_page/check_password_page.dart';
import 'package:game_team_creator_admin_panel/screens/password_page/create_password_page.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HiveHelper.hasPassword
        ? const CheckPasswordPage()
        : const CreatePasswordPage();
  }
}
