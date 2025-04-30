import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class RlCard extends StatelessWidget {
  const RlCard({
    this.borderRadius = kBorderRadius,
    super.key,
    this.color,
    this.gradient,
    this.child,
    this.padding,
  });
  final Color? color;
  final Gradient? gradient;
  final double borderRadius;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(0.5),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: color ?? context.theme.cardColor,
              gradient: gradient,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
