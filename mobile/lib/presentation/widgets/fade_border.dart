import 'package:flutter/material.dart';

class FadeBorder extends StatelessWidget {
  const FadeBorder({
    super.key,
    this.gradient,
    this.blendMode = BlendMode.dstIn,
    this.disabled = false,
    required this.child,
  });

  final Gradient? gradient;
  final BlendMode blendMode;
  final bool disabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return disabled
        ? child
        : ShaderMask(
            shaderCallback: (rect) {
              return gradient != null
                  ? gradient!.createShader(rect)
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.white],
                      stops: [0.0, 0.09],
                    ).createShader(rect);
            },
            blendMode: blendMode,
            child: child,
          );
  }
}
