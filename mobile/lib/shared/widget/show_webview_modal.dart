import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/screens/screens.dart";

Future<T?> showWebViewModal<T>({
  required BuildContext context,
  required String url,
  required String title,
  bool useCupertino = false,
}) async {
  if (useCupertino) {
    return CupertinoScaffold.showCupertinoModalBottomSheet(
      useRootNavigator: true,
      context: context,
      duration: 300.ms,
      animationCurve: Curves.fastEaseInToSlowEaseOut,
      builder: (context) => WebViewScreen(
        url: url,
        title: title,
      ),
    );
  }

  return showModalBottomSheet(
    useRootNavigator: true,
    enableDrag: false,
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    constraints:
        BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
    builder: (context) => WebViewScreen(
      url: url,
      title: title,
    ),
  );
}
