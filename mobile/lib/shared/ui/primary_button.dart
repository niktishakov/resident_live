import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/shared/shared.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.vibrate = false,
    this.fontSize = 20.0,
    this.textColor,
    this.textStyle,
    this.backgroundColor,
    this.gradient,
    this.onPressed,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.animationDuration,
    this.padding,
    this.behavior = HitTestBehavior.deferToChild,
  });

  final Widget? leading;
  final String label;
  final bool vibrate;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final double? fontSize;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? trailing;
  final Duration? animationDuration;
  final EdgeInsetsGeometry? padding;
  final HitTestBehavior behavior;
  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      borderRadius: kBorderRadius,
      vibrate: vibrate,
      behaviour: behavior,
      onPressed: enabled ? (_) => onPressed?.call() : null,
      child: AnimatedContainer(
        duration: animationDuration ?? kDefaultDuration,
        decoration: BoxDecoration(
          borderRadius: kBorderRadius,
          gradient: enabled ? gradient : null,
          color: enabled
              ? backgroundColor ?? context.theme.primaryColor
              : context.theme.disabledColor,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: leading!,
                  ),
                  Gap(8),
                ],
                Text(
                  label,
                  style: textStyle ??
                      context.theme.textTheme.labelLarge?.copyWith(
                        fontSize: fontSize,
                        color:
                            textColor ?? context.theme.scaffoldBackgroundColor,
                      ),
                ),
                if (trailing != null) ...[
                  Gap(8),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: trailing!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
