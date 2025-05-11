import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:resident_live/app/init_app.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/shared.dart";

void showToast(BuildContext context, String content) {
  final fToast = FToast();
  fToast.init(navigatorKey.currentContext!);

  final Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.orangeAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, color: context.theme.scaffoldBackgroundColor),
        const SizedBox(width: 12.0),
        Text(
          content,
          style: TextStyle(color: context.theme.scaffoldBackgroundColor),
        ),
      ],
    ),
  );
  VibrationService.instance.warning();
  fToast.showToast(
    child: toast,
    positionedToastBuilder: (context, child, gravity) => Positioned(
      top: context.mediaQuery.padding.top,
      left: 0,
      right: 0,
      child: child,
    ),
    // gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
    fadeDuration: const Duration(milliseconds: 200),
  );
}
