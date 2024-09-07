import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

import '../../core/constants.dart';
import '../../services/vibration_service.dart';

class BouncingButton extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final Function(PointerEvent)? onPressed;
  final bool vibrate;
  final bool debounce;
  final Duration debounceDuration;
  final HitTestBehavior? behaviour;

  BouncingButton({
    Key? key,
    required this.child,
    this.borderRadius,
    this.onPressed,
    this.vibrate = true,
    this.debounce = false,
    this.debounceDuration = const Duration(seconds: 3),
    this.behaviour,
  }) : super(key: key);

  @override
  _BouncingState createState() => _BouncingState();
}

class _BouncingState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late double _opacity;
  late Lock? _lock;
  late AnimationController _controller;

  Offset _initPosition = Offset.zero;
  bool _mayCallOnPress = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.debounce) {
      _lock = Lock(); // create lock only if debounce is enabled
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool checkPosition(PointerEvent event) {
    return (event.localPosition.dx - _initPosition.dx).abs() > 5 ||
        (event.localPosition.dy - _initPosition.dy).abs() > 5;
  }

  _callPressCallback(PointerEvent event) {
    if (widget.debounce) {
      if (_lock!.locked) return; // prevent multiple taps
      return _lock!.synchronized(() async {
        try {
          widget.onPressed?.call(event);
          await Future.delayed(widget.debounceDuration);
        } catch (e) {
          print(e);
        }
      });
    } else {
      widget.onPressed?.call(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    _opacity = _controller.value;
    final behaviour = widget.behaviour ?? HitTestBehavior.deferToChild;
    final borderRadius = widget.borderRadius ?? kBorderRadius;

    return Listener(
      behavior: behaviour,
      onPointerDown: (event) {
        if (widget.debounce && _lock?.locked == true) {
          return; // prevent multiple taps
        }

        if (widget.vibrate) VibrationService.instance.tap();
        if (mounted) {
          _controller.forward();
          _timer?.cancel();

          setState(() {
            _initPosition = event.localPosition;
            _mayCallOnPress = true;
            _timer = Timer(const Duration(milliseconds: 1000), () {
              if (mounted) {
                _controller.reverse();
                setState(() => _mayCallOnPress = false);
              }
            });
          });
        }
      },
      onPointerMove: (event) {
        if (widget.debounce && _lock?.locked == true) {
          return; // prevent multiple taps
        }

        if (mounted) {
          if (checkPosition(event)) {
            _controller.reverse();
            setState(() => _mayCallOnPress = false);
          }
        }
      },
      onPointerUp: (event) async {
        if (widget.debounce && _lock?.locked == true) {
          return; // prevent multiple taps
        }

        if (mounted) {
          if (_mayCallOnPress == true) {
            await Future.delayed(const Duration(milliseconds: 100));

            _callPressCallback(event);
            if (mounted) unawaited(_controller.reverse());
            if (widget.vibrate) VibrationService.instance.light();
          }

          _timer?.cancel();
          if (mounted) {
            setState(() {
              _timer = null;
            });
          }
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: Opacity(
                opacity: _opacity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
