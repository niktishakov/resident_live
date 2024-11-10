import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/domain/domain.dart';
import 'package:resident_live/shared/shared.dart';

class ResidencyRulesModal extends StatelessWidget {
  const ResidencyRulesModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final textStyle = theme.body16M.copyWith(
      color: theme.textPrimaryOnColor,
    );

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0 * value,
            sigmaY: 5.0 * value,
          ),
          child: IntrinsicHeight(
            child: RlCard(
              gradient: kMainGradient,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: context.mediaQuery.padding.bottom + 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Grabber(),
                  const Gap(12),
                  Text(
                    "Residency Rules Resources",
                    style: theme.body18.copyWith(
                      fontWeight: FontWeight.w300,
                      color: theme.textPrimaryOnColor,
                    ),
                  ),
                  const Gap(48),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TransparentButton(
                            width: double.infinity,
                            onPressed: () {
                              showWebViewModal(
                                context: context,
                                url: kpmgUrl,
                                title: "KPMG",
                              );
                            },
                            leading: AppAssetImage(
                              AppAssets.redirect,
                              width: 22,
                            ),
                            child: Text("Read on KPMG", style: textStyle),
                          ),
                          TransparentButton(
                            onPressed: () {
                              showWebViewModal(
                                context: context,
                                url: deloitteUrl,
                                title: "Deloitte",
                              );
                            },
                            leading: AppAssetImage(
                              AppAssets.redirect,
                              width: 22,
                            ),
                            child: Text("Read on Deloitte", style: textStyle),
                          ),
                          TransparentButton(
                            onPressed: () {
                              showWebViewModal(
                                context: context,
                                url: pwcUrl,
                                title: "PWC",
                              );
                            },
                            leading: AppAssetImage(
                              AppAssets.redirect,
                              width: 22,
                            ),
                            child: Text("Read on PWC", style: textStyle),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
