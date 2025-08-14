part of "../residence_details_screen.dart";

const double _dragThreshold = 200.0;

class _SwipeToDismiss extends StatefulWidget {
  const _SwipeToDismiss({
    required this.child,
    required this.onDismiss,
    required this.animationController,
  });

  final Widget child;
  final VoidCallback onDismiss;
  final AnimationController animationController;

  @override
  State<_SwipeToDismiss> createState() => _SwipeToDismissState();
}

class _SwipeToDismissState extends State<_SwipeToDismiss> {
  bool _isDraggingFromTop = false;
  double _initialDragY = 0.0;

  @override
  Widget build(BuildContext context) {
    final animationController = widget.animationController;
    final child = widget.child;

    return GestureDetector(
      onPanCancel: () {
        if (animationController.value != 0) {
          animationController.reverse();
        }
      },
      onPanUpdate: (details) {
        final delta = details.delta.dy;
        animationController.value += delta / _dragThreshold;

        if (animationController.value > 0.8) {
          animationController.forward().then((_) {
            context.pop();
          });
        }
      },
      onPanEnd: (details) {
        if (animationController.value != 0) {
          animationController.reverse();
        }
      },

      child: NotificationListener<ScrollNotification>(
        child: child,
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification &&
              notification.metrics.pixels <= 0 &&
              notification.dragDetails != null &&
              notification.dragDetails!.delta.dy > 0) {
            if (!_isDraggingFromTop) {
              _isDraggingFromTop = true;
              _initialDragY = notification.dragDetails!.globalPosition.dy;
              setState(() {});
            }

            if (_isDraggingFromTop) {
              final currentDrag = notification.dragDetails!.globalPosition.dy;
              final dragDelta = currentDrag - _initialDragY;

              animationController.value = (dragDelta / _dragThreshold).clamp(0.0, 1.0);

              if (animationController.value > 0.8) {
                animationController.forward().then((_) {
                  if (mounted) {
                    context.pop();
                  }
                });
              }
              return true;
            }
          } else if (notification is ScrollEndNotification) {
            setState(() {});

            if (_isDraggingFromTop) {
              if (animationController.value <= 0.8) {
                _logger.debug("RDS_LOG: reverse");
                animationController.reverse();
              }

              return true;
            }
          }

          return false;
        },
      ),
    );
  }
}
