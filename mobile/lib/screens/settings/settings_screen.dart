import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/settings/cubit/auth_by_biometrics_cubit.dart";
import "package:resident_live/screens/settings/cubit/stop_auth_cubit.dart";
import "package:resident_live/screens/settings/cubit/toggle_biometrics_cubit.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/bloc_consumer.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.sliver_header.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResourceBlocBuilder<GetUserCubit, UserEntity>(
      bloc: getIt<GetUserCubit>(),
      orElse: () => CupertinoActivityIndicator(),
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
                      AiSliverHeader(titleText: S.of(context).settingsTitle),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(addRepaintBoundaries: false, [
                            //             Builder(
                            //               builder: (context) {
                            //                 final isEnabled = getIt<ToggleBiometricsCubit>().state;
                            //                 final isSupported = getIt<IsBiometricsSupportedCubit>().state.maybeMap(
                            //                       orElse: () => false,
                            //                       data: (state) => state.data,
                            //                     );

                            //                 return AbsorbPointer(
                            //                   absorbing: !isSupported,
                            //                   child: AnimatedOpacity(
                            //                     opacity: isSupported ? 1 : 0,
                            //                     duration: const Duration(milliseconds: 200),
                            //                     child: SettingsButton(
                            //                       asset: isSupported ? AppAssets.faceid : AppAssets.touchid,
                            //                       title: "Biometric Access",
                            //                       subtitle: isEnabled ? S.of(context).commonOn : S.of(context).commonOff,
                            //                       onTap: () async {
                            //                         final userId = getIt<CreateUserCubit>().state.maybeMap(
                            //                               orElse: () => "",
                            //                               data: (state) => state.data.id,
                            //                             );

                            //                         if (userId.isEmpty) {
                            //                           context.goNamed(ScreenNames.splash);
                            //                           return;
                            //                         }

                            //                         getIt<ToggleBiometricsCubit>().action(userId);
                            //                       },
                            //                       trailing: CupertinoSwitch(
                            //                         value: isEnabled,
                            //                         activeTrackColor: context.theme.colorScheme.primary,
                            //                         onChanged: (value) {}, // TODO: the same as above
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 );
                            //               },
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     const Gap(12),
                            //     SettingsButton(
                            //       icon: Icons.language,
                            //       title: S.of(context).settingsLanguage,
                            //       onTap: () {
                            //         context.pushNamed(ScreenNames.language);
                            //       },
                            //     ),
                            //     const Gap(12),
                            //     SettingsButton(
                            //       icon: CupertinoIcons.bell,
                            //       title: S.of(context).settingsNotifications,
                            //       onTap: () {
                            //         // Handle Notifications settings
                            //       },
                            //     ),
                            //     const Gap(32),
                            //     SettingsButton(
                            //       asset: AppAssets.person2Wave2,
                            //       title: S.of(context).settingsShareWithFriends,
                            //       trailing: const SizedBox(),
                            //       onTap: () {
                            //         getIt<ShareService>().shareText(appStoreLink);
                            //       },
                            //     ),
                            //     const Gap(12),
                            //     SettingsButton(
                            //       icon: CupertinoIcons.star,
                            //       title: S.of(context).settingsRateUs,
                            //       onTap: () {
                            //         launchUrl(Uri.parse(appStoreLink));
                            //       },
                            //     ),
                            //     const Gap(32),
                            //     SettingsButton(
                            //       icon: CupertinoIcons.checkmark_shield,
                            //       title: S.of(context).settingsPrivacyPolicy,
                            //       onTap: () async {
                            //         await showWebViewModal(
                            //           context: context,
                            //           url: privacyPolicyUrl,
                            //           title: S.of(context).settingsPrivacyPolicy,
                            //         );
                            //       },
                            //     ),
                            //     const Gap(12),
                            //     SettingsButton(
                            //       asset: AppAssets.terms,
                            //       title: S.of(context).settingsTermsOfUse,
                            //       onTap: () async {
                            //         await showWebViewModal(
                            //           context: context,
                            //           url: termsOfUseUrl,
                            //           title: S.of(context).settingsTermsOfUse,
                            //         );
                            //       },
                            //     ),
                            //     const Gap(12),
                            //     SettingsButton(
                            //       asset: AppAssets.info,
                            //       title: S.of(context).settingsAboutApp,
                            //       trailing: const SizedBox(),
                            //       onTap: () async {
                            //         await showCupertinoDialog(
                            //           context: context,
                            //           barrierDismissible: true,
                            //           builder: (context) => Consumer<DeviceInfoService>(
                            //             builder: (context, deviceInfo, child) {
                            //               return CupertinoAlertDialog(
                            //                 title: Text(S.of(context).settingsAboutApp),
                            //                 content: Column(
                            //                   children: [
                            //                     const Gap(12),
                            //                     Text(deviceInfo.appName),
                            //                     Text(
                            //                       "${deviceInfo.appVersion} (${deviceInfo.buildNumber})",
                            //                     ),
                            //                   ],
                            //                 ),
                            //               );
                            //             },
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //     const ReportBugButton(),
                            //     const Gap(12),
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

  void _onToggleBiometricsListen(BuildContext context, bool enabled) {
    if (enabled) {
      getIt<AuthByBiometricsCubit>().loadResource();
    } else {
      getIt<StopAuthCubit>().loadResource();
    }
  }

  void _onAuthByBiometricsListen(BuildContext context, ResourceState<bool> state) {}
}
