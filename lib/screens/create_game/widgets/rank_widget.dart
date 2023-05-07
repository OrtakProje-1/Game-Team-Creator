import 'package:flutter/material.dart';
import 'package:game_team_creator_admin_panel/models/rank.dart';
import 'package:game_team_creator_admin_panel/screens/create_game/widgets/text_field.dart';

class RankWidget extends StatefulWidget {
  const RankWidget({super.key, required this.rank, this.onDelete});
  final Rank rank;
  final ValueChanged<Rank>? onDelete;

  @override
  State<RankWidget> createState() => _RankWidgetState();
}

class _RankWidgetState extends State<RankWidget> {
  final TextEditingController id = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController image = TextEditingController();

  @override
  void initState() {
    id.text = widget.rank.id.toString();
    name.text = widget.rank.name.toString();
    image.text = widget.rank.image.toString();
    setListeners();
    super.initState();
  }

  void setListeners() {
    id.addListener(() {
      widget.rank.id = int.parse(id.text.trim());
    });
    name.addListener(() {
      widget.rank.name = name.text.trim();
    });
    image.addListener(() {
      widget.rank.image = image.text.trim();
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
                    isReadOnly: true,
                    controller: id,
                    placeholder: "Rank Id",
                  ),
                  CustomTextField(
                    controller: name,
                    placeholder: "Rank İsmi",
                  ),
                  CustomTextField(
                    controller: image,
                    placeholder: "Resim Url'i",
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onDelete?.call(widget.rank);
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}
