import "package:flutter/cupertino.dart";
import "package:gap/gap.dart";

class TransparentButton extends StatelessWidget {
  const TransparentButton({
    required this.onPressed, required this.child, super.key,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.leading,
    this.alignment,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? leading;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Align(
          alignment: alignment ?? Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, const Gap(8)],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
