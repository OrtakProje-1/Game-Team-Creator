import 'package:flutter/material.dart';
import 'package:game_team_creator_admin_panel/models/role.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/widgets/text_field.dart';

class RoleWidget extends StatefulWidget {
  const RoleWidget({super.key, required this.role, this.onDelete});
  final Role role;
  final ValueChanged<Role>? onDelete;

  @override
  State<RoleWidget> createState() => _RoleWidgetState();
}

class _RoleWidgetState extends State<RoleWidget> {
  final TextEditingController id = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController desciption = TextEditingController();

  @override
  void initState() {
    id.text = widget.role.id.toString();
    name.text = widget.role.name.toString();
    desciption.text = widget.role.description.toString();
    setListeners();
    super.initState();
  }

  void setListeners() {
    id.addListener(() {
      widget.role.id = int.parse(id.text.trim());
    });
    name.addListener(() {
      widget.role.name = name.text.trim();
    });
    desciption.addListener(() {
      widget.role.description = desciption.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomTextField(
                    controller: id,
                    placeholder: "Rol Id",
                  ),
                  CustomTextField(
                    controller: name,
                    placeholder: "Rol İsmi",
                  ),
                  CustomTextField(
                    controller: desciption,
                    placeholder: "Rol Açıklaması",
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onDelete?.call(widget.role);
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}
