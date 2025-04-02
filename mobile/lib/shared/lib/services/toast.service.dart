import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/shared/lib/extensions/context_extension.dart";
import "package:resident_live/shared/lib/services/vibration_service.dart";

enum ToastStatus {
  success,
  failure,
  warning,
}

class ToastService {
  ToastService._();

  static ToastService? _instance;

  static ToastService get instance {
    assert(
      _instance != null,
      "Remember to initialise ToastService by calling its init method",
    );
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

    final now = DateTime.now();
    if (_lastMessage == message &&
        _lastDateTime != null &&
        now.difference(_lastDateTime!).inSeconds < 3) {
      return;
    }

    _lastMessage = message;
    _lastDateTime = now;

    final icon = status == ToastStatus.success
        ? const Icon(CupertinoIcons.check_mark, color: Color(0xff9AD55B))
        : status == ToastStatus.failure
            ? const Icon(CupertinoIcons.xmark, color: Color(0xffFF6643))
            : const Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: Colors.amber,
              );

    final Widget toast = Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0x336A6D83)),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 20,
            color: Color(0xffE4E5E5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const Gap(10),
          Flexible(
            child: Text(
              message,
              style: GoogleFonts.workSans(
                fontSize: 18.0,
                color: const Color(0xff6A6D83),
              ),
            ),
          ),
        ],
      ),
    );

    VibrationService.instance.warning();

    fToast.showToast(
      child: toast,
      positionedToastBuilder: (context, child) => Positioned(
        top: context.mediaQuery.padding.top,
        left: 0,
        right: 0,
        child: child,
      ),
      toastDuration: const Duration(seconds: 2),
      fadeDuration: const Duration(milliseconds: 200),
    );
  }
}
