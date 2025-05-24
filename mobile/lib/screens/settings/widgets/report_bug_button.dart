import "package:data/data.dart";
import "package:flutter/cupertino.dart";
import "package:gap/gap.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/shared.dart";

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
      onPressed:
          _isLoading
              ? null
              : () async {
                setState(() => _isLoading = true);

                final logFile = getIt<LoggerService>().logFile;
                final logger = getIt<LoggerService>();

                if (await logFile.exists()) {
                  try {
                    await getIt<ShareService>().shareFile(logFile);
                  } catch (e) {
                    logger.error(e);
                    if (context.mounted) {
                      ToastService.instance.showToast(
                        context,
                        message: "Failed to send bug report: ${e.toString()}",
                      );
                    }
                  }
                } else {
                  logger.error("Log file not found!");
                  if (context.mounted) {
                    ToastService.instance.showToast(context, message: "Log file not found!");
                  }
                }
                setState(() => _isLoading = false);
              },
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Report a Bug", style: theme.body18),
            if (_isLoading) ...[const Gap(8), const CupertinoActivityIndicator()],
          ],
        ),
      ),
    );
  }
}
