import "package:data/data.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:go_router/go_router.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/screens/settings/cubit/auth_by_biometrics_cubit.dart";
import "package:resident_live/screens/settings/cubit/is_biometrics_supported_cubit.dart";
import "package:resident_live/screens/settings/cubit/stop_auth_cubit.dart";
import "package:resident_live/screens/settings/cubit/toggle_biometrics_cubit.dart";
import "package:resident_live/screens/settings/widgets/settings_button.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/bloc_consumer.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.sliver_header.dart";
import "package:url_launcher/url_launcher.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResourceBlocBuilder<GetUserCubit, UserEntity>(
      bloc: context.watch<GetUserCubit>(),
      orElse: CupertinoActivityIndicator.new,
      data: (data) {
        return MultiBlocListener(
          listeners: [
            BlocListener<ToggleBiometricsCubit, bool>(
              bloc: getIt<ToggleBiometricsCubit>(),
              listener: _onToggleBiometricsListen,
            ),
            ResourceBlocListener<AuthByBiometricsCubit, bool>(
              bloc: getIt<AuthByBiometricsCubit>(),
              listener: _onAuthByBiometricsListen,
            ),
          ],
          child: CupertinoScaffold(
            overlayStyle: getSystemOverlayStyle,
            transitionBackgroundColor: const Color(0xff121212),
            body: Builder(
              builder: (context) {
                return Material(
                  child: CustomScrollView(
                    slivers: [
                      AiSliverHeader(titleText: context.t.settingsTitle),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(addRepaintBoundaries: false, [
                            Builder(
                              builder: (context) {
                                final isEnabled = getIt<ToggleBiometricsCubit>().state;
                                final isSupported = getIt<IsBiometricsSupportedCubit>().state
                                    .maybeMap(orElse: () => false, data: (state) => state.data);

                                return AbsorbPointer(
                                  absorbing: !isSupported,
                                  child: AnimatedOpacity(
                                    opacity: isSupported ? 1 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SettingsButton(
                                      asset: isSupported ? AppAssets.faceid : AppAssets.touchid,
                                      title: "Biometric Access",
                                      subtitle: isEnabled
                                          ? context.t.commonOn
                                          : context.t.commonOff,
                                      onTap: () async {
                                        final userId = getIt<GetUserCubit>().state.maybeMap(
                                          orElse: () => "",
                                          data: (state) => state.data.id,
                                        );

                                        if (userId.isEmpty) {
                                          context.goNamed(ScreenNames.splash);
                                          return;
                                        }

                                        getIt<ToggleBiometricsCubit>().action(userId);
                                      },
                                      trailing: CupertinoSwitch(
                                        value: isEnabled,
                                        activeTrackColor: context.theme.colorScheme.primary,
                                        onChanged: (value) {}, // TODO: the same as above
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            context.vBox12,
                            SettingsButton(
                              icon: Icons.language,
                              title: context.t.settingsLanguage,
                              onTap: () {
                                context.pushNamed(ScreenNames.language);
                              },
                            ),

                            context.vBox32,
                            SettingsButton(
                              asset: AppAssets.person2Wave2,
                              title: context.t.settingsShareWithFriends,
                              trailing: const SizedBox(),
                              onTap: () {
                                getIt<ShareService>().shareText(appStoreLink);
                              },
                            ),
                            context.vBox12,
                            SettingsButton(
                              icon: CupertinoIcons.star,
                              title: context.t.settingsRateUs,
                              onTap: () {
                                launchUrl(Uri.parse(appStoreLink));
                              },
                            ),

                            context.vBox32,
                            SettingsButton(
                              icon: CupertinoIcons.checkmark_shield,
                              title: context.t.settingsPrivacyPolicy,
                              onTap: () async {
                                await launchUrl(Uri.parse(privacyPolicyUrl));
                              },
                            ),
                            context.vBox12,
                            SettingsButton(
                              asset: AppAssets.terms,
                              title: context.t.settingsTermsOfUse,
                              onTap: () async {
                                await launchUrl(Uri.parse(termsOfUseUrl));
                              },
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  //     const Gap(12),
  //     SettingsButton(
  //       icon: CupertinoIcons.bell,
  //       title: context.t.settingsNotifications,
  //       onTap: () {
  //         // Handle Notifications settings
  //       },
  //     ),

  //     const Gap(12),
  //     SettingsButton(
  //       asset: AppAssets.info,
  //       title: context.t.settingsAboutApp,
  //       trailing: const SizedBox(),
  //       onTap: () async {
  //         await showCupertinoDialog(
  //           context: context,
  //           barrierDismissible: true,
  //           builder: (context) => Consumer<DeviceInfoService>(
  //             builder: (context, deviceInfo, child) {
  //               return CupertinoAlertDialog(
  //                 title: Text(context.t.settingsAboutApp),
  //                 content: Column(
  //                   children: [
  //                     const Gap(12),
  //                     Text(deviceInfo.appName),
  //                     Text(
  //                       "${deviceInfo.appVersion} (${deviceInfo.buildNumber})",
  // ),
  // ],
  // ),
  // );
  // },
  // ),
  // );
  // },
  // ),
  // const ReportBugButton(),
  // const Gap(12),
  //           ]),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  // },
  // ),
  // ),
  // );
  // },
  // );
  // }

  void _onToggleBiometricsListen(BuildContext context, bool enabled) {
    if (enabled) {
      getIt<AuthByBiometricsCubit>().loadResource();
    } else {
      getIt<StopAuthCubit>().loadResource();
    }
  }

  void _onAuthByBiometricsListen(BuildContext context, ResourceState<bool> state) {}
}
