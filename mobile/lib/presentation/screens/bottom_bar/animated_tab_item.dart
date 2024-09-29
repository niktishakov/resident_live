import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/core/assets/rl.asset.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/screens/bottom_bar/bottom_bar.dart';

import '../../../core/assets/export.dart';

class AnimatedTabItem extends StatefulWidget {
  const AnimatedTabItem({
    super.key,
    this.iconSize = 24,
    required this.label,
    required this.itemFill,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });
  final String label;
  final double iconSize;
  final RlAsset itemFill;
  final RlAsset item;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<AnimatedTabItem> createState() => _AnimatedTabItemState();
}

class _AnimatedTabItemState extends State<AnimatedTabItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final iconSize = widget.iconSize;
    final item = widget.item;
    final itemFill = widget.itemFill;
    final isSelected = widget.isSelected;
    final textColor = isSelected
        ? context.theme.colorScheme.secondary
        : context.theme.colorScheme.secondary.withOpacity(0.75);

    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white.withOpacity(0.0001),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: SizedBox.square(
                  dimension: iconSize,
                  child: Container(
                      key: ValueKey("${item.path}_tab_icon"),
                      child: widget.isSelected
                          ? RlAssetImage(
                              itemFill,
                              height: iconSize,
                              width: iconSize,
                              color: context.theme.colorScheme.secondary,
                              fit: BoxFit.contain,
                            )
                          : RlAssetImage(
                              item,
                              height: iconSize,
                              width: iconSize,
                              color: context.theme.colorScheme.secondary,
                              fit: BoxFit.contain,
                            ))),
            ),
            Text(
              label,
              style: GoogleFonts.workSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textColor,
                letterSpacing: 0.1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
