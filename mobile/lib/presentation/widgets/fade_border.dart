import 'package:flutter/material.dart';

class FadeBorder extends StatelessWidget {
  const FadeBorder({
    super.key,
    this.gradient,
    this.blendMode = BlendMode.dstIn,
    this.disabled = false,
    this.bidirectional = false,
    required this.child,
  });

  final Gradient? gradient;
  final BlendMode blendMode;
  final bool disabled;
  final bool bidirectional;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return disabled
        ? child
        : ShaderMask(
            shaderCallback: (rect) {
              return gradient != null
                  ? gradient!.createShader(rect)
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: bidirectional
                          ? [
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                              Colors.transparent,
                            ]
                          : [
                              Colors.transparent,
                              Colors.white,
                            ],
                      stops:
                          bidirectional ? [0.0, 0.09, 0.91, 1.0] : [0.0, 0.09],
                    ).createShader(rect);
            },
            blendMode: blendMode,
            child: child,
          );
  }
}
