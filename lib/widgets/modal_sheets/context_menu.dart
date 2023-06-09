import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/utils/iterable_utils.dart';

import 'modal_sheet.dart';

class ContextMenu extends StatelessWidget {
  final List<ContextMenuAction> actions;

  const ContextMenu(this.actions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[...actions]
                //TODO: using divider here
                .separate(const Divider(height: 0.5, thickness: 0.5))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ContextMenuAction extends StatelessWidget {
  final IconData icon;
  final GestureTapCallback onTap;
  final String label;

  const ContextMenuAction({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
        context.pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.offset,
          vertical: Insets.lg,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: Insets.lg),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
