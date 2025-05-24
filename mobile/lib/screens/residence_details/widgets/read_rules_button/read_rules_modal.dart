import "dart:ui";

import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/residence_details/widgets/read_rules_button/widgets/preview.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/shared.dart";
import "package:url_launcher/url_launcher.dart";

part "widgets/preview_grid.dart";
part "widgets/preview_card.dart";
part "widgets/modal_header.dart";

Future<void> showResidencyRulesModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    useSafeArea: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    ),
    builder: (_) => const _ResidencyRulesModal(),
  );
}

class _ResidencyRulesModal extends StatelessWidget {
  const _ResidencyRulesModal();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0 * value, sigmaY: 5.0 * value),
          child: RlCard(
            gradient: kMainGradient,
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: context.mediaQuery.viewInsets.bottom + 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Grabber(),
                context.vBox12,
                _ModalHeader(title: S.of(context).detailsResidencyRulesResources),
                context.vBox40,
                const _PreviewGrid(),
              ],
            ),
          ),
        );
      },
    );
  }
}
