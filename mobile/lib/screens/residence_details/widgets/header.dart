import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/domain/domain.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:share_plus/share_plus.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
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
    return Row(
      children: [
        if (isFocused) ...[
          AppAssetImage(
            AppAssets.target,
            width: 18,
            height: 18,
            color: context.theme.colorScheme.secondary,
          ),
          Gap(8),
        ],
        Expanded(
          child: Row(
            children: [
              Text(
                countryName,
                maxLines: 1,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 26),
              ),
              if (isHere) ...[
                Gap(4),
                Here(shorter: true),
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
            color: Colors.white.withOpacity(0.85),
          ),
        ),
        Gap(16),
        BouncingButton(
          onPressed: (_) {
            VibrationService.instance.tap();
            context.pop();
          },
          child: Icon(CupertinoIcons.clear_circled_solid,
              size: 34, color: Colors.white.withOpacity(0.85)),
        )
      ],
    );
  }

  Future<void> _captureAndShareScreenshot() async {
    final RenderRepaintBoundary boundary =
        screenKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    await Share.shareXFiles(
      [
        XFile.fromData(
          bytes,
          name: 'residence_status.png',
          mimeType: 'image/png',
        ),
      ],
      text:
          "Track your global residency journey with Resident Live! Download now: ${appStoreLink}",
    );
  }
}
