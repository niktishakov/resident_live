import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:resident_live/shared/shared.dart";

class Cloud {
  const Cloud({required this.x, required this.y, required this.size, required this.speed});

  final double x;
  final double y;
  final double size;
  final double speed;
}

class CloudsPainter extends CustomPainter {
  CloudsPainter(this.animationValue, this.theme, this.cloudImage);
  final double animationValue;
  final RlTheme theme;
  final ui.Image? cloudImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (cloudImage == null) return;

    final paint = Paint()
      ..colorFilter = ColorFilter.mode(theme.bgWhite.withValues(alpha: 0.1), BlendMode.srcATop);

    // Cloud positions and sizes
    final clouds = <Cloud>[
      const Cloud(x: 0.1, y: 0.2, size: 0.05, speed: 35.0),
      const Cloud(x: 0.6, y: 0.15, size: 0.06, speed: 25.0),
      const Cloud(x: 0.3, y: 0.35, size: 0.1, speed: 15.0),
      const Cloud(x: 0.8, y: 0.4, size: 0.07, speed: 30.0),
      const Cloud(x: 0.0, y: 0.6, size: 0.09, speed: 15.0),
      const Cloud(x: 0.5, y: 0.65, size: 0.045, speed: 45.0),
      const Cloud(x: 0.9, y: 0.8, size: 0.07, speed: 18.0),
    ];

    for (final cloud in clouds) {
      final baseX = cloud.x * size.width;
      final speed = cloud.speed;
      final cloudScale = cloud.size;
      final cloudWidth = cloudImage!.width.toDouble() * cloudScale;

      // Calculate seamless movement: when animation goes from 0 to 1, clouds complete full cycle
      final fullCycleDistance = size.width + cloudWidth;
      final animatedOffset = animationValue * speed * fullCycleDistance;

      final x = baseX + animatedOffset;
      final y = cloud.y * size.height;

      // Wrap around screen seamlessly
      final wrappedX = x % fullCycleDistance - cloudWidth;

      // Draw cloud image
      canvas.save();
      canvas.translate(wrappedX, y);
      canvas.scale(cloudScale, cloudScale);
      canvas.drawImage(cloudImage!, Offset.zero, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CloudsPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue || cloudImage != oldDelegate.cloudImage;
  }

  static Future<ui.Image> loadCloudImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
