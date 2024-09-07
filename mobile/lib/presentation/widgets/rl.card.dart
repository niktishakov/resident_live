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
  });
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    final border = brightness == Brightness.dark
        ? null
        : Border.all(
            width: 0,
            color: context.theme.colorScheme.secondary.withOpacity(0.1));

    final _borderRadius = borderRadius ?? kBorderRadius;

    return Material(
      borderRadius: _borderRadius,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
              color: color ?? context.theme.cardColor,
              gradient: LinearGradient(
                colors: [
                  context.theme.colorScheme.secondary.withOpacity(0.2),
                  Colors.transparent
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(0.5),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: _borderRadius.copyWith(
                topLeft: Radius.circular(_borderRadius.topLeft.y - 0.5),
                topRight: Radius.circular(_borderRadius.topRight.y - 0.5),
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
