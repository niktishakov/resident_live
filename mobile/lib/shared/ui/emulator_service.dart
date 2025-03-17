import 'package:flutter/material.dart';

class EmulatorService {
  static Widget iPhoneSE2022({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(375, 667),
      devicePixelRatio: 2.0,
      safeArea: const EdgeInsets.only(top: 20, bottom: 0),
      deviceName: 'iPhone SE (2022)',
      child: child,
    );
  }

  static Widget iPhone13ProMax({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(428, 926),
      devicePixelRatio: 3.0,
      safeArea: const EdgeInsets.only(top: 47, bottom: 34),
      deviceName: 'iPhone 13 Pro Max',
      child: child,
    );
  }

  static Widget iPhone12Mini({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(375, 812), // Logical resolution (points)
      devicePixelRatio: 3.0,
      safeArea: const EdgeInsets.only(top: 44, bottom: 34),
      deviceName: 'iPhone 12 mini',
      child: child,
    );
  }

  static Widget iPhone7({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(375, 667),
      devicePixelRatio: 2.0,
      safeArea: const EdgeInsets.only(top: 0, bottom: 0),
      deviceName: 'iPhone 7',
      child: child,
    );
  }

  static Widget iPhone8Plus({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(414, 736),
      devicePixelRatio: 3.0,
      safeArea: const EdgeInsets.only(top: 20, bottom: 0),
      deviceName: 'iPhone 8 Plus',
      child: child,
    );
  }

  static Widget iPhoneXR({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(414, 896), // Logical resolution (points)
      devicePixelRatio: 2.0,
      safeArea: const EdgeInsets.only(top: 48, bottom: 34),
      deviceName: 'iPhone XR',
      child: child,
    );
  }

  static Widget iPhoneX({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(375, 812), // Logical resolution (points)
      devicePixelRatio: 3.0,
      safeArea: const EdgeInsets.only(top: 44, bottom: 34),
      deviceName: 'iPhone X',
      child: child,
    );
  }

  static Widget iPhone15({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(390, 844),
      devicePixelRatio: 3.0,
      safeArea: const EdgeInsets.only(top: 47, bottom: 34),
      deviceName: 'iPhone 15',
      child: child,
    );
  }

  static Widget iPadPro11({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(834, 1194),
      devicePixelRatio: 2.0,
      safeArea: const EdgeInsets.only(top: 24, bottom: 20),
      deviceName: 'iPad Pro 11-inch',
      child: child,
    );
  }

  static Widget iPadPro129({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(1024, 1366),
      devicePixelRatio: 2.0,
      safeArea: const EdgeInsets.only(top: 24, bottom: 20),
      deviceName: 'iPad Pro 12.9-inch',
      child: child,
    );
  }

  static Widget customDevice({required Widget child}) {
    return _DeviceEmulator(
      size: const Size(300, 500), // Logical resolution (points)
      devicePixelRatio: 3.0,
      safeArea: const EdgeInsets.only(top: 44, bottom: 34),
      deviceName: 'Custom Device',
      child: child,
    );
  }
}

class _DeviceEmulator extends StatelessWidget {

  const _DeviceEmulator({
    Key? key,
    required this.size,
    required this.devicePixelRatio,
    required this.safeArea,
    required this.deviceName,
    required this.child,
  }) : super(key: key);
  final Size size;
  final double devicePixelRatio;
  final EdgeInsets safeArea;
  final String deviceName;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = _calculateScale(constraints);

        return SizedBox(
          width: size.width * scale,
          height: size.height * scale,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: size,
                  padding: safeArea,
                  devicePixelRatio: devicePixelRatio,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Stack(
                        children: [
                          child,
                          Positioned(
                            top: 10 + safeArea.top / 2,
                            right: 10,
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  deviceName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateScale(BoxConstraints constraints) {
    final scaleWidth = constraints.maxWidth / size.width;
    final scaleHeight = constraints.maxHeight / size.height;
    return scaleWidth < scaleHeight ? scaleWidth : scaleHeight;
  }
}
