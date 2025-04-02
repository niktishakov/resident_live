import "package:flutter/cupertino.dart";
import "package:go_router/go_router.dart";

/// Make the bottom sheet dismissible by tapping on the background
class MakeDismissible extends StatelessWidget {
  const MakeDismissible({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pop(),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ),
    );
  }
}
