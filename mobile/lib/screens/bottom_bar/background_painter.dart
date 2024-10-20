import 'package:flutter/material.dart';

class CustomBottomNavBarPainter extends CustomPainter {
  CustomBottomNavBarPainter({this.borderRadius = 45.0});
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xff2B2B2B);
    final path = Path();

    final centerX = size.width / 2;
    final notchWidth = size.width * 0.5;
    final notchHeight = size.height / 5;

    // Start from the bottom left
    path.moveTo(borderRadius, size.height);

    // Left side
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius / 2),
      clockwise: true,
    );
    path.lineTo(centerX - notchWidth / 4 - 20, 0);

    // Left curve of the notch
    path.quadraticBezierTo(
      centerX - notchWidth / 4,
      0,
      centerX - notchWidth / 4,
      notchHeight,
    );

    // Bottom curve of the notch
    path.arcToPoint(
      Offset(centerX + notchWidth / 4, notchHeight),
      radius: Radius.circular(notchWidth / 4),
      clockwise: false,
    );

    // Right curve of the notch
    path.quadraticBezierTo(
      centerX + notchWidth / 4,
      0,
      centerX + notchWidth / 4 + 20,
      0,
    );

    // Right side
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height),
      radius: Radius.circular(borderRadius / 2),
      clockwise: true,
    );

    // Bottom side
    path.lineTo(borderRadius, size.height);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
