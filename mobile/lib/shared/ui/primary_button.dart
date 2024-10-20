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
    this.backgroundColor,
    this.onPressed,
    this.enabled = true,
    this.leading,
  });

  final Widget? leading;
  final String label;
  final bool vibrate;
  final Color? textColor;
  final Color? backgroundColor;
  final double? fontSize;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      borderRadius: kBorderRadius,
      vibrate: vibrate,
      onPressed: enabled ? (_) => onPressed?.call() : null,
      child: AnimatedContainer(
        duration: kDefaultDuration,
        decoration: BoxDecoration(
          borderRadius: kBorderRadius,
          color: enabled
              ? backgroundColor ?? context.theme.primaryColor
              : context.theme.disabledColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, Gap(8)],
              Text(label,
                  style: context.theme.textTheme.labelLarge?.copyWith(
                    fontSize: fontSize,
                    color: textColor ?? context.theme.scaffoldBackgroundColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
