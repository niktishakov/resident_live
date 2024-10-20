import 'dart:math';

extension RandomExtension on Random {
  static int randomSerialNumber() {
    return Random().nextInt(0xffffffff);
  }
}
