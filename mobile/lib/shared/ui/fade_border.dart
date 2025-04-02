import "package:flutter/material.dart";

class FadeBorder extends StatelessWidget {
  const FadeBorder({
    required this.child, super.key,
    this.gradient,
    this.blendMode = BlendMode.dstIn,
    this.disabled = false,
    this.bidirectional = false,
    this.stops,
    this.direction = Axis.vertical,
  });

  final Gradient? gradient;
  final BlendMode blendMode;
  final bool disabled;
  final bool bidirectional;
  final Axis direction;
  final Widget child;
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    return disabled
        ? child
        : ShaderMask(
            shaderCallback: (rect) {
              return gradient != null
                  ? gradient!.createShader(rect)
                  : LinearGradient(
                      begin: direction == Axis.vertical
                          ? Alignment.topCenter
                          : Alignment.centerLeft,
                      end: direction == Axis.vertical
                          ? Alignment.bottomCenter
                          : Alignment.centerRight,
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
                      stops: stops ??
                          (bidirectional
                              ? [0.0, 0.09, 0.91, 1.0]
                              : [0.0, 0.09]),
                    ).createShader(rect);
            },
            blendMode: blendMode,
            child: child,
          );
  }
}
