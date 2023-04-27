import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:flutter/material.dart';

class MultiEditButton extends StatelessWidget {
  final bool inEditMode;
  final VoidCallback onClickEdit;
  final VoidCallback onClickMove;
  final VoidCallback onClickDelete;
  final VoidCallback onClickSelectAll;

  const MultiEditButton({
    Key? key,
    required this.inEditMode,
    required this.onClickMove,
    required this.onClickDelete,
    required this.onClickEdit,
    required this.onClickSelectAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inEditMode) {
      return Padding(
        padding: AllpassEdgeInsets.smallRPadding,
        child: IconButton(
          splashColor: Colors.transparent,
          icon: Icon(Icons.sort),
          onPressed: onClickEdit,
        ),
      );
    }

    return Row(
      children: [
        PopupMenuButton<_MultiEditAction>(
          onSelected: (value) {
            switch (value) {
              case _MultiEditAction.delete:
                onClickDelete();
                break;
              case _MultiEditAction.move:
                onClickMove();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _MultiEditAction.move,
              child: Text("移动"),
            ),
            PopupMenuItem(
              value: _MultiEditAction.delete,
              child: Text(
                "删除",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        IconButton(
          splashColor: Colors.transparent,
          icon: Icon(Icons.select_all),
          onPressed: onClickSelectAll,
        ),
        IconButton(
          splashColor: Colors.transparent,
          icon: Icon(Icons.clear),
          onPressed: onClickEdit,
        ),
        Padding(padding: AllpassEdgeInsets.smallRPadding),
      ],
    );
  }
}

enum _MultiEditAction {
  move,
  delete,
}
