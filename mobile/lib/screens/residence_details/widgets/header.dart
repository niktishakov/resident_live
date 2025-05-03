import "dart:ui";

import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/shared.dart";
import "package:share_plus/share_plus.dart";

class Header extends StatelessWidget {
  const Header({
    required this.countryName,
    required this.isFocused,
    required this.isHere,
    required this.screenKey,
    super.key,
  });

  final String countryName;
  final bool isFocused;
  final bool isHere;
  final GlobalKey<State<StatefulWidget>> screenKey;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _HeaderContent(
        countryName: countryName,
        isFocused: isFocused,
        isHere: isHere,
        screenKey: screenKey,
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent({
    required this.countryName,
    required this.isFocused,
    required this.isHere,
    required this.screenKey,
  });

  final String countryName;
  final bool isFocused;
  final bool isHere;
  final GlobalKey<State<StatefulWidget>> screenKey;

  @override
  Widget build(BuildContext context) {
    final color = context.theme.colorScheme.secondary;
    return Row(
      children: [
        const SizedBox().animate(delay: 100.ms).swap(
              builder: (context, _) => TweenAnimationBuilder(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 0, end: isFocused ? 1 : 0),
                builder: (context, value, child) {
                  return SizedBox(
                    width: value * 30,
                    height: 20,
                    child: Transform.translate(
                      offset: Offset(-20 * (1 - value), 0),
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: OverflowBox(
                          minWidth: 30,
                          maxWidth: 30,
                          minHeight: 20,
                          maxHeight: 20,
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    AppAssetImage(
                      AppAssets.target,
                      width: 20,
                      height: 20,
                      color: color,
                    ),
                    const Gap(8),
                  ],
                ),
              ),
            ),
        Expanded(
          child: Row(
            children: [
              Text(
                countryName,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                ),
              ),
              if (isHere) ...[
                const Gap(4),
                const Here(shorter: true),
              ],
            ],
          ),
        ),
        BouncingButton(
          onPressed: (_) {
            VibrationService.instance.tap();
            _captureAndShareScreenshot();
          },
          child: AppAssetImage(
            AppAssets.squareAndArrowUpCircle,
            width: 32,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        const Gap(16),
        BouncingButton(
          onPressed: (_) {
            VibrationService.instance.tap();
            context.pop();
          },
          child: Icon(
            CupertinoIcons.clear_circled_solid,
            size: 34,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }

  Future<void> _captureAndShareScreenshot() async {
    final boundary = screenKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            name: "residence_status.png",
            mimeType: "image/png",
          ),
        ],
        text: "Track your global residency journey with Resident Live! Download now: $appStoreLink",
      ),
    );
  }
}
