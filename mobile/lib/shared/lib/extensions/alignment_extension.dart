import 'package:flutter/material.dart';

extension AlignmentExt on Alignment {
  /// Transpose interpolation values by transition: [0, 1] -> [-1, 1]
  Alignment transpose() {
    return Alignment(
      x * 2.0 - 1.0,
      y * 2.0 - 1.0,
    );
  }
}
