import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/screens/bottom_bar/animated_tab_item.dart";
import "package:resident_live/shared/shared.dart";

class AiBottomBar extends StatelessWidget {
  const AiBottomBar({required this.state, required this.child, super.key});

  final GoRouterState state;
  final Widget child;

  List<AiBottomBarItem> getItems(BuildContext context) {
    final t = context.t;

    return [
      AiBottomBarItem(
        icon: AppAssets.personCircle,
        iconFill: AppAssets.personCircleFill,
        label: t.commonFocusTab,
        path: ScreenNames.home,
      ),
      AiBottomBarItem(
        icon: AppAssets.airplane,
        iconFill: AppAssets.airplaneFill,
        label: t.commonTripsTab,
        path: ScreenNames.trips,
      ),
      AiBottomBarItem(
        icon: AppAssets.gearshape,
        iconFill: AppAssets.gearshapeFill,
        label: t.commonSettingsTab,
        path: ScreenNames.settings,
        animation: ({child, isSelected = false}) => TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
          duration: 200.ms,
          builder: (_, value, c) => Transform.rotate(angle: value * pi / 3, child: c),
          child: child,
        ),
      ),
    ];
  }

  String get currentPath => state.uri.toString();

  @override
  Widget build(BuildContext context) {
    final items = getItems(context);
    final theme = context.rlTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: child,
      extendBody: true,
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 78,
            margin: EdgeInsets.only(bottom: context.mediaQuery.padding.bottom, left: 24, right: 24),
            decoration: BoxDecoration(
              gradient: kMainGradient.withOpacity(0.65),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(color: theme.bgPrimary, blurRadius: 80, offset: const Offset(0, 78)),
              ],
            ),
            child: Center(
              child: Stack(
                children: [
                  SizedBox(
                    width: 280,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final item in items)
                          Expanded(
                            flex: item.label.isEmpty ? 1 : 2,
                            child: _buildTabItem(context, item),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, AiBottomBarItem item) {
    final isSelected = currentPath == item.path;
    const iconSize = 30.0;

    return LayoutBuilder(
      builder: (context, ctrx) {
        return AnimatedTabItem(
          label: item.label,
          animation: item.animation,
          itemFill: item.iconFill,
          item: item.icon,
          isSelected: isSelected,
          iconSize: iconSize,
          onPressed: () {
            final isTheSameTab = GoRouterState.of(context).fullPath == item.path;
            if (isTheSameTab && context.canPop()) {
              context.pop();
              return;
            }

            // AiAnalytics.instance.setCurrentScreen(item.path);
            context.go(item.path);
          },
        );
      },
    );
  }
}

class AiBottomBarItem {
  const AiBottomBarItem({
    required this.path,
    required this.icon,
    required this.iconFill,
    required this.label,
    this.animation,
  });
  final String path;
  final AppAsset icon;
  final AppAsset iconFill;
  final String label;
  final TweenAnimationBuilder Function({Widget? child, bool isSelected})? animation;
}
