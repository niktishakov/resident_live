import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:local_auth/local_auth.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:provider/provider.dart";
import "package:resident_live/domain/domain.dart";
import "package:resident_live/features/features.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/screens/settings/widgets/settings_button.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/ui/rl.sliver_header.dart";
import "package:url_launcher/url_launcher.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("SettingsScreen>> ${S.of(context).settingsNotifications}");
    return CupertinoScaffold(
      overlayStyle: getSystemOverlayStyle,
      transitionBackgroundColor: const Color(0xff121212),
      body: Builder(
        builder: (context) {
          return Material(
            child: CustomScrollView(
              slivers: [
                AiSliverHeader(
                  titleText: S.of(context).settingsTitle,
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                  sliver: SliverList(
                    delegate:
                        SliverChildListDelegate(addRepaintBoundaries: false, [
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                        },
                        builder: (context, state) {
                          final authCubit = context.read<AuthCubit>();

                          return SettingsButton(
                            asset: state.biometricType == BiometricType.face
                                ? AppAssets.faceid
                                : AppAssets
                                    .touchid, // Assuming you have a touchid asset
                            title: "${authCubit.biometricTitle} Access",
                            subtitle: state.isEnabled
                                ? S.of(context).commonOn
                                : S.of(context).commonOff,
                            onTap: () async {
                              if (!state.isSupported && state.error != null) {
                                print("Open App Settings");
                              }
                              if (state.isEnabled) {
                                await authCubit.toggleBiometricAuth();
                              } else {
                                await authCubit.authenticateAndToggle();
                              }
                            },
                            trailing: CupertinoSwitch(
                              value: state.isEnabled,
                              activeTrackColor:
                                  context.theme.colorScheme.primary,
                              onChanged: (value) async {
                                if (value) {
                                  await authCubit.authenticateAndToggle();
                                } else {
                                  await authCubit.toggleBiometricAuth();
                                }
                              },
                            ),
                          );
                        },
                      ),
                      const Gap(12),
                      SettingsButton(
                        icon: Icons.language,
                        title: S.of(context).settingsLanguage,
                        onTap: () {
                          context.pushNamed(ScreenNames.language);
                        },
                      ),
                      const Gap(12),
                      SettingsButton(
                        icon: CupertinoIcons.bell,
                        title: S.of(context).settingsNotifications,
                        onTap: () {
                          // Handle Notifications settings
                        },
                      ),
                      const Gap(32),
                      SettingsButton(
                        asset: AppAssets.person2Wave2,
                        title: S.of(context).settingsShareWithFriends,
                        trailing: const SizedBox(),
                        onTap: () {
                          ShareService.instance.shareText(appStoreLink);
                        },
                      ),
                      const Gap(12),
                      SettingsButton(
                        icon: CupertinoIcons.star,
                        title: S.of(context).settingsRateUs,
                        onTap: () {
                          launchUrl(Uri.parse(appStoreLink));
                        },
                      ),
                      const Gap(32),
                      SettingsButton(
                        icon: CupertinoIcons.checkmark_shield,
                        title: S.of(context).settingsPrivacyPolicy,
                        onTap: () async {
                          await showWebViewModal(
                            context: context,
                            url: privacyPolicyUrl,
                            title: S.of(context).settingsPrivacyPolicy,
                          );
                        },
                      ),
                      const Gap(12),
                      SettingsButton(
                        asset: AppAssets.terms,
                        title: S.of(context).settingsTermsOfUse,
                        onTap: () async {
                          await showWebViewModal(
                            context: context,
                            url: termsOfUseUrl,
                            title: S.of(context).settingsTermsOfUse,
                          );
                        },
                      ),
                      const Gap(12),
                      SettingsButton(
                        asset: AppAssets.info,
                        title: S.of(context).settingsAboutApp,
                        trailing: const SizedBox(),
                        onTap: () async {
                          await showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => Consumer<DeviceInfoService>(
                              builder: (context, deviceInfo, child) {
                                return CupertinoAlertDialog(
                                  title: Text(S.of(context).settingsAboutApp),
                                  content: Column(
                                    children: [
                                      const Gap(12),
                                      Text(deviceInfo.appName),
                                      Text(
                                        "${deviceInfo.appVersion} (${deviceInfo.buildNumber})",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const ReportBugButton(),
                      const Gap(12),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
