import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/core/assets/rl.assets.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/navigation/screen_names.dart';
import 'package:resident_live/presentation/screens/bottom_bar/animated_tab_item.dart';
import 'package:resident_live/presentation/widgets/bouncing_button.dart';

import '../../../core/assets/rl.asset.dart';
import '../../../core/assets/rl.asset_image.dart';
import '../../../services/vibration_service.dart';
import 'background_painter.dart';

class AiBottomBar extends StatelessWidget {
  AiBottomBar({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  final List<AiBottomBarItem> _items = [
    AiBottomBarItem(
      icon: RlAssets.personCircle,
      iconFill: RlAssets.personCircleFill,
      label: 'Focus',
      path: ScreenNames.home,
    ),
    AiBottomBarItem(
      icon: RlAssets.sliderHorizontal2Gobackward,
      iconFill: RlAssets.sliderHorizontal2Gobackward,
      label: '',
      path: ScreenNames.onboarding,
    ),
    AiBottomBarItem(
      icon: RlAssets.gearshape,
      iconFill: RlAssets.gearshapeFill,
      label: 'Settings',
      path: ScreenNames.settings,
    ),
  ];

  String get currentPath => state.uri.toString();

  @override
  Widget build(BuildContext context) {
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
                size: Size(280, 78),
                painter: CustomBottomNavBarPainter(),
              ),
              SizedBox(
                width: 280,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var item in _items)
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
    final isScanFood = item.path == ScreenNames.onboarding;
    final iconSize = isScanFood ? 66.0 : 30.0;
    final textColor = isScanFood
        ? context.theme.primaryColor
        : isSelected
            ? Colors.black
            : const Color(0xff868991);

    if (isScanFood) {
      return LayoutBuilder(
        builder: (context, ctrx) {
          print(ctrx);
          return BouncingButton(
            // vibrate: false,
            onPressed: (_) {
              // VibrationService.instance.tap();
              context.push(ScreenNames.addResidency);
            },
            child: ColoredBox(
              color: Colors.transparent,
              child: Transform.translate(
                offset: Offset(0, isScanFood ? -23 : 0),
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
                        child: RlAssetImage(
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
        print("${item.label} >> $ctrx");
        return AnimatedTabItem(
          label: item.label,
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
  final String path;
  final RlAsset icon;
  final RlAsset iconFill;
  final String label;

  const AiBottomBarItem({
    required this.path,
    required this.icon,
    required this.iconFill,
    required this.label,
  });
}

class BlurredBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Clip it so the blur is only applied within the bottom bar boundaries
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Blur effect
        child: Container(
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
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
