import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/shared.dart";

enum ToastStatus { success, failure, warning }

class ToastService {
  ToastService._();

  static ToastService? _instance;

  static ToastService get instance {
    assert(_instance != null, "Remember to initialise ToastService by calling its init method");
    return _instance!;
  }

  static Future<void> init() async {
    assert(_instance == null);

    _instance = ToastService._();
  }

  String? _lastMessage;
  DateTime? _lastDateTime;

  void showToast(
    BuildContext context, {
    required String message,
    ToastStatus status = ToastStatus.success,
  }) {
    final fToast = FToast();
    fToast.init(context);
    final theme = RlTheme();

    final now = DateTime.now();
    if (_lastMessage == message &&
        _lastDateTime != null &&
        now.difference(_lastDateTime!).inSeconds < 3) {
      return;
    }

    _lastMessage = message;
    _lastDateTime = now;

    final (iconData, iconColor) = switch (status) {
      ToastStatus.success => (CupertinoIcons.check_mark, theme.iconSuccess),
      ToastStatus.failure => (CupertinoIcons.xmark, theme.iconDanger),
      ToastStatus.warning => (CupertinoIcons.exclamationmark_triangle, theme.bgWarning),
    };

    final Widget toast = Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.0), color: theme.bgModal),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: iconColor),
          const Gap(10),
          Flexible(
            child: Text(
              message,
              style: GoogleFonts.workSans(fontSize: 18.0, color: theme.textPrimary),
            ),
          ),
        ],
      ),
    );

    VibrationService.instance.warning();

    fToast.showToast(
      child: toast,
      positionedToastBuilder: (context, child, gravity) =>
          Positioned(top: context.mediaQuery.viewPadding.top, left: 0, right: 0, child: child),
      toastDuration: const Duration(seconds: 3),
      fadeDuration: const Duration(milliseconds: 200),
    );
  }
}
