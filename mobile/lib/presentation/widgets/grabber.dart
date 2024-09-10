import 'package:flutter/widgets.dart';
import 'package:resident_live/core/extensions/context.extension.dart';

class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 6),
  });

  final Color? color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: 36,
          height: 5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.secondary.withOpacity(0.3),
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
          ),
        ),
      ),
    );
  }
}
