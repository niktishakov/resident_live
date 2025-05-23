import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/residence_details/cubit/clear_focus_cubit.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/transparent_button.dart";

class RemoveResidenceButton extends StatelessWidget {
  const RemoveResidenceButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: TransparentButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text("Remove Country"),
              content: const Text(
                "Are you sure you want to remove this country from tracking?",
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text("Remove"),
                  onPressed: () {
                    context.pop();
                    context.pop();
                    getIt<ClearFocusCubit>().loadResource();
                  },
                ),
              ],
            ),
          );
        },
        leading: const Icon(
          CupertinoIcons.rectangle_stack_badge_minus,
          color: Colors.redAccent,
          size: 24,
        ),
        child: Text(
          S.of(context).detailsRemoveCountry,
          style: theme.body14.copyWith(
            fontWeight: FontWeight.w300,
            color: theme.textDanger,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
