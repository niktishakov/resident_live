import "package:flutter/cupertino.dart";
import "package:gap/gap.dart";
import "package:resident_live/shared/shared.dart";

class DetailsProgressBar extends StatelessWidget {
  const DetailsProgressBar({
    required this.progress,
    required this.progressInPercentage,
    required this.status,
    super.key,
  });
  final double progress;
  final int progressInPercentage;
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return LayoutBuilder(
      builder: (context, ctrx) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$progressInPercentage%",
              style: theme.title48.copyWith(
                height: 1.2,
                fontFamily: kFontFamilySecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(4),
            Container(
              width: ctrx.maxWidth,
              height: 32,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: DiagonalProgressBar(progress: progress, isAnimationEnabled: true),
              ),
            ),
            context.vBox4,
            Text(status, style: theme.body14.copyWith(color: theme.textSecondary)),
          ],
        );
      },
    );
  }
}
