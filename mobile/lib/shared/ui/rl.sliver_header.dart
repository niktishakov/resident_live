import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/screens/residence_details/residence_details_screen2.dart';
import 'package:resident_live/shared/shared.dart';

class AiSliverAppBar extends StatelessWidget {
  const AiSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.trailing,
    this.leading,
    this.showBottomBorder = true,
    this.stretch = true,
    this.centerTitle,
    this.showLargeTitle = true,
    this.bgColor = Colors.transparent,
    this.previousPageTitle,
  });
  final String title;
  final List<Widget>? actions;
  final Widget? trailing;
  final Widget? leading;
  final bool showBottomBorder;
  final bool stretch;
  final bool? centerTitle;
  final bool showLargeTitle;
  final Color bgColor;
  final String? previousPageTitle;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      brightness: Brightness.light,
      backgroundColor: bgColor,
      border: Border.all(color: Colors.transparent),
      padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
      stretch: stretch,
      previousPageTitle: previousPageTitle,
      automaticallyImplyTitle: !showLargeTitle,
      alwaysShowMiddle: true,
      middle: !showLargeTitle
          ? Text(
              title,
              style: GoogleFonts.workSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.theme.colorScheme.secondary,
              ),
            )
          : null,
      leading: leading ??
          CupertinoNavigationBarBackButton(
            color: Colors.black, // your desired color
            previousPageTitle: previousPageTitle,
            onPressed: () => context.pop(),
          ),
      largeTitle: showLargeTitle
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                      color: context.theme.colorScheme.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 30 / 24,
                      // letterSpacing: 0.2,
                    )),
              ],
            )
          : null,
      trailing: trailing,
    );
  }
}

class AiSliverHeader extends StatelessWidget {
  const AiSliverHeader({
    super.key,
    this.height = 44.0,
    this.child,
    this.titleText = '',
    this.actions = const [],
  });
  final double height;
  final Widget? child;
  final String titleText;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final totalHeight = height + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: totalHeight,
        maxHeight: totalHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                if (context.canPop())
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: AiBackButton(),
                  ),
                Center(
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  static double feedMaxOffset = 50;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final borderOpacity = (shrinkOffset / feedMaxOffset).clamp(0.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 30 * borderOpacity,
              sigmaY: 30 * borderOpacity,
            ),
            child: Container(
              height: maxExtent,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface
                    .withOpacity(borderOpacity * 0.8),
                border: Border(
                  bottom: BorderSide(
                    color:
                        context.theme.dividerColor.withOpacity(borderOpacity),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox.expand(child: child),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class AiBackButton extends StatelessWidget {
  const AiBackButton({
    super.key,
    this.onPressed,
    this.padding,
    this.title,
  });

  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: CupertinoButton(
          padding: padding ?? const EdgeInsets.only(left: 12, right: 0),
          minSize: 24,
          onPressed: onPressed ?? () => context.pop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_outlined,
                color: context.theme.primaryColor,
                size: 22,
                weight: 4,
              ),
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: context.theme.primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    .animate()
                    .slideX(
                      begin: 1,
                      end: 0,
                      delay: 100.ms,
                      duration: 300.ms,
                      curve: Curves.fastOutSlowIn,
                    )
                    .fade(begin: 0.01)
            ],
          )),
    );
  }
}
