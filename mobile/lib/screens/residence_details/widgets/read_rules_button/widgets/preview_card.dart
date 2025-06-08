part of "../read_rules_modal.dart";

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    const borderRadius = 8.0;
    const internalPadding = 4.0;
    const internalBorderRadius = borderRadius - internalPadding;

    return GestureDetector(
      onTap: () => _onCardTap(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: theme.borderAccent, width: 4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(internalPadding),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(internalBorderRadius),
                      child: Preview(url: url, title: title),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: theme.bgAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppAssetImage(AppAssets.redirect, width: 16, color: theme.iconPrimary),
                        const Gap(4),
                        Text(
                          "${context.t.detailsReadOn} $title",
                          style: context.rlTheme.body14.copyWith(
                            color: context.rlTheme.textPrimaryOnColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
        ],
      ),
    );
  }

  Future<void> _onCardTap(BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      if (context.mounted) {
        ToastService.instance.showToast(context, message: "Something went wrong");
      }
    }
  }
}
