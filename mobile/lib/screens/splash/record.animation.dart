part of "splash_screen.dart";

class RecordingAnimation extends StatefulWidget {
  @override
  _RecordingAnimationState createState() => _RecordingAnimationState();
}

class _RecordingAnimationState extends State<RecordingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _finalSizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Total duration for all animations
    );

    // Initial scale (from 0 to 30px radius)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.1, curve: Curves.linear),
      ),
    );

    // Bounce between 30px and 20px radius three times
    _bounceAnimation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 30.0, end: 20.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 20.0, end: 30.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 30.0, end: 20.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 20.0, end: 30.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.linear),
      ),
    );

    // Final size growth (from 30px to 80px radius)
    _finalSizeAnimation = Tween<double>(begin: 30.0, end: 90.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.linear),
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double size = _controller.value <= 0.1
            ? _scaleAnimation.value
            : _controller.value < 0.7
                ? _bounceAnimation.value
                : _finalSizeAnimation.value;
        return Container(
          width: size * 2, // Multiply by 2 to convert radius to diameter
          height: size * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        );
      },
    );
  }
}
