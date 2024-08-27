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
            width: 0.5,
            color: context.theme.colorScheme.secondary.withOpacity(0.1));
    final boxShadow = brightness == Brightness.dark
        ? null
        : [
            BoxShadow(
              offset: Offset(5, 5),
              color: context.theme.colorScheme.secondary.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ];

    return Material(
      elevation: brightness == Brightness.dark ? 0 : 5,
      borderRadius: borderRadius ?? kBorderRadius,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? kBorderRadius,
          color: color ?? context.theme.cardColor,
          gradient: gradient,
          border: border,
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}
