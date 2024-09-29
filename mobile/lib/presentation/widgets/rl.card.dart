import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';

class RlCard extends StatelessWidget {
  const RlCard({
    super.key,
    this.color,
    this.gradient,
    this.borderRadius,
    this.child,
    this.padding,
  });
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    final border = brightness == Brightness.dark
        ? null
        : Border.all(
            width: 0,
            color: context.theme.colorScheme.secondary.withOpacity(0.1));

    final _borderRadius = borderRadius ?? kBorderRadius;
    final _padding = padding ?? EdgeInsets.all(16.0);

    return Material(
      borderRadius: _borderRadius,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(0.5),
            padding: _padding,
            decoration: BoxDecoration(
              borderRadius: _borderRadius.copyWith(
                topLeft: Radius.circular(_borderRadius.topLeft.y - 0.5),
                topRight: Radius.circular(_borderRadius.topRight.y - 0.5),
              ),
              border: Border.all(
                color: context.theme.colorScheme.surface.withOpacity(0.25),
                width: 1,
              ),
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
