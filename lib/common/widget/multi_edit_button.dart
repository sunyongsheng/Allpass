import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/l10n/l10n_support.dart';
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

    var l10n = context.l10n;
    return Row(
      children: [
        PopupMenuButton<_MultiEditAction>(
          onSelected: (value) => switch (value) {
            _MultiEditAction.delete => onClickDelete(),
            _MultiEditAction.move => onClickMove(),
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _MultiEditAction.move,
              child: Text(l10n.move),
            ),
            PopupMenuItem(
              value: _MultiEditAction.delete,
              child: Text(
                l10n.delete,
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
