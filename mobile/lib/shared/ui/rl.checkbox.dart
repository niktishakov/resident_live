import "package:flutter/cupertino.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:resident_live/shared/shared.dart";

class RlCheckbox extends StatefulWidget {
  const RlCheckbox({
    required this.value,
    required this.onToggle,
    super.key,
  });
  final bool value;
  final ValueChanged<bool> onToggle;

  @override
  RlCheckboxState createState() => RlCheckboxState();
}

class RlCheckboxState extends State<RlCheckbox> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: 150.ms,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RlCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _playBounceAnimation();
    }
  }

  void _playBounceAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _playBounceAnimation();
        widget.onToggle(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: widget.value ? context.theme.primaryColor : null,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1,
                  color: widget.value ? context.theme.primaryColor : const Color(0xff8E8E8E),
                ),
              ),
              child: Center(
                child: widget.value
                    ? Icon(
                        CupertinoIcons.check_mark,
                        color: context.theme.colorScheme.surface,
                        size: 18,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
