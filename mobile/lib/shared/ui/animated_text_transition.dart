import 'package:flutter/material.dart';

class AnimatedTextTransition extends StatefulWidget {
  const AnimatedTextTransition({
    Key? key,
    required this.texts,
    required this.index,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);
  final List<Widget> texts;
  final int index;
  final Duration animationDuration;

  @override
  _AnimatedTextTransitionState createState() => _AnimatedTextTransitionState();
}

class _AnimatedTextTransitionState extends State<AnimatedTextTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;

  int _currentIndex = 0;
  int _nextIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),);

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ),);
  }

  @override
  void didUpdateWidget(AnimatedTextTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _currentIndex) {
      _nextIndex = widget.index;
      _controller.forward().then((_) {
        setState(() {
          _currentIndex = _nextIndex;
        });
        _controller.reset();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          _buildAnimatedText(_currentIndex),
          if (_controller.isAnimating) _buildAnimatedText(_nextIndex, true),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(int index, [bool isNext = false]) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: isNext
              ? _positionAnimation.value + const Offset(0, 1)
              : _positionAnimation.value,
          child: Opacity(
            opacity:
                isNext ? 1 - _opacityAnimation.value : _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Center(child: widget.texts[index]),
      ),
    );
  }
}
