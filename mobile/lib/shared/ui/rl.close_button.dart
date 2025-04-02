import "package:flutter/cupertino.dart";
import "package:go_router/go_router.dart";

import "package:resident_live/shared/lib/services/vibration_service.dart";

class RlCloseButton extends StatelessWidget {
  const RlCloseButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        VibrationService.instance.tap();
        context.pop();
      },
      child: Icon(
        CupertinoIcons.clear_circled_solid,
        color: color,
        size: 32,
      ),
    );
  }
}
