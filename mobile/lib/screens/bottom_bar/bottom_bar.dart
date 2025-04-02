import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/screens/bottom_bar/animated_tab_item.dart";
import "package:resident_live/screens/bottom_bar/background_painter.dart";
import "package:resident_live/shared/shared.dart";

class AiBottomBar extends StatelessWidget {
  const AiBottomBar({
    required this.state, required this.child, super.key,
  });

  final GoRouterState state;
  final Widget child;

  List<AiBottomBarItem> getItems(BuildContext context) {
    return [
      AiBottomBarItem(
        icon: AppAssets.personCircle,
        iconFill: AppAssets.personCircleFill,
        label: S.of(context).commonFocusTab,
        path: ScreenNames.home,
      ),
      AiBottomBarItem(
        icon: AppAssets.sliderHorizontal2Gobackward,
        iconFill: AppAssets.sliderHorizontal2Gobackward,
        label: "",
        path: ScreenNames.onboarding,
        animation: (isSelected, child) => TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
          duration: 200.ms,
          builder: (_, value, c) =>
              Transform.rotate(angle: -value * pi / 3, child: c),
          child: child,
        ),
      ),
      AiBottomBarItem(
        icon: AppAssets.gearshape,
        iconFill: AppAssets.gearshapeFill,
        label: S.of(context).commonSettingsTab,
        path: ScreenNames.settings,
        animation: (isSelected, child) => TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
          duration: 200.ms,
          builder: (_, value, c) =>
              Transform.rotate(angle: value * pi / 3, child: c),
          child: child,
        ),
      ),
    ];
  }

  String get currentPath => state.uri.toString();

  @override
  Widget build(BuildContext context) {
    final items = getItems(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        height: 78,
        margin: EdgeInsets.only(
          bottom: context.mediaQuery.padding.bottom,
        ),
        child: Center(
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(280, 78),
                painter: CustomBottomNavBarPainter(),
              ),
              SizedBox(
                width: 280,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final item in items)
                      Expanded(
                        flex: item.label.isEmpty ? 1 : 2,
                        child: ColoredBox(
                          color: Colors.amber.withOpacity(0.00001),
                          child: _buildTabItem(context, item),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, AiBottomBarItem item) {
    final isSelected = currentPath == item.path;
    final isMiddleButton = item.path == ScreenNames.onboarding;
    final iconSize = isMiddleButton ? 66.0 : 30.0;
    final textColor = isMiddleButton
        ? context.theme.primaryColor
        : isSelected
            ? Colors.black
            : const Color(0xff868991);

    if (isMiddleButton) {
      if (item.animation != null) {
        return item.animation!(
          isSelected,
          LayoutBuilder(
            builder: (context, ctrx) {
              return GestureDetector(
                onTap: () {
                  VibrationService.instance.tap();
                  context.push(ScreenNames.manageCountries);
                },
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Transform.translate(
                    offset: Offset(0, isMiddleButton ? -23 : 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: AppAssetImage(
                              item.icon,
                              width: 40,
                              height: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, ctrx) {
          return GestureDetector(
            onTap: () {
              VibrationService.instance.tap();
              context.push(ScreenNames.manageCountries);
            },
            child: ColoredBox(
              color: Colors.transparent,
              child: Transform.translate(
                offset: Offset(0, isMiddleButton ? -23 : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: AppAssetImage(
                          item.icon,
                          width: 40,
                          height: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

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
            final isTheSameTab =
                GoRouterState.of(context).fullPath == item.path;
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
  final TweenAnimationBuilder Function(bool, Widget)? animation;
}

class BlurredBottomNavBar extends StatelessWidget {
  const BlurredBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Clip it so the blur is only applied within the bottom bar boundaries
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Blur effect
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5), // Semi-transparent background
          ),
          child: BottomNavigationBar(
            backgroundColor:
                Colors.transparent, // Background should be transparent
            elevation: 0, // Remove the shadow
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
            selectedItemColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
