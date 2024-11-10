import 'package:flutter/material.dart';
import 'package:resident_live/shared/shared.dart';

class RlLoader extends StatefulWidget {
  const RlLoader({
    Key? key,
    this.width,
    this.height,
    this.duration,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Duration? duration;
  @override
  _RlLoaderState createState() => _RlLoaderState();
}

class _RlLoaderState extends State<RlLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 2),
    )..repeat(); // Rotate indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: widget.width ?? 100.0,
        height: widget.height ?? 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(AppAssets.circularLoader.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
