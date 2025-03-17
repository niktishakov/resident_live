import 'package:flutter/material.dart';

class AppDialogs {
  static Future<void> showError({
    required BuildContext context,
    required String message,
    String title = 'Error',
    VoidCallback? onDismiss,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
            ),
          ],
        );
      },
    );
  }
}
