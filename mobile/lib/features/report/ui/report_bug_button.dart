
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/shared/shared.dart';

class ReportBugButton extends StatefulWidget {
  const ReportBugButton({super.key});

  @override
  State<ReportBugButton> createState() => _ReportBugButtonState();
}

class _ReportBugButtonState extends State<ReportBugButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);

              // Show modal popup to get user message
              final message = await showCupertinoDialog<String>(
                context: context,
                builder: (context) {
                  var inputText = '';
                  return CupertinoAlertDialog(
                    title: Text('Send a Bug Report'),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CupertinoTextField(
                        placeholder:
                            'Write a description of the issue (optional)',
                        onChanged: (value) => inputText = value,
                        maxLines: 5,
                        minLines: 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        autofocus: true,
                        autocorrect: true,
                        maxLength: 1000,
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () => context.pop(),
                        child: Text('Cancel'),
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () => context.pop(inputText),
                        child: Text('Send'),
                      ),
                    ],
                  );
                },
              );

              if (message != null) {
                final logFile = AiLogger.logFile;
                final logger = AiLogger('SettingsScreen');

                if (await logFile.exists()) {
                  try {
                    await ShareService.instance.shareFile(logFile);
                    ToastService.instance.showToast(context,
                        message: 'Log file shared successfully',);
                  } catch (e) {
                    logger.error(e);
                    ToastService.instance.showToast(context,
                        message: 'Failed to send bug report: ${e.toString()}',);
                  }
                } else {
                  logger.error('Log file not found!');
                  ToastService.instance
                      .showToast(context, message: 'Log file not found!');
                }
              }
              setState(() => _isLoading = false);
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Report a Bug', style: theme.body18),
          if (_isLoading) const CupertinoActivityIndicator(),
        ],
      ),
    );
  }
}
