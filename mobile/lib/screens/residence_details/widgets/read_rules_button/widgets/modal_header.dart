part of "../read_rules_modal.dart";

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return Row(
      children: [
        Text(title, style: theme.body18M.copyWith(color: theme.textPrimary)),
        const Spacer(),
        GestureDetector(
          onTap: () => context.pop(),
          child: Icon(CupertinoIcons.xmark_circle_fill, size: 26, color: theme.textPrimary),
        ),
      ],
    );
  }
}
