import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/core/extensions/context.extension.dart';

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
        Container(
          height: maxExtent,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(borderOpacity),
            border: Border(
              bottom: BorderSide(
                color: context.theme.dividerColor.withOpacity(borderOpacity),
                width: 1.0,
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
  });

  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: CupertinoButton(
          padding: padding ?? const EdgeInsets.only(left: 12, right: 0),
          minSize: 24,
          onPressed: onPressed ??
              () {
                context.pop();
              },
          child: Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
            size: 24,
          )),
    );
  }
}
