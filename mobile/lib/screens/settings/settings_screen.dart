import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:resident_live/domain/domain.dart';
import 'package:resident_live/features/features.dart';
import 'package:resident_live/features/report/ui/report_bug_button.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/shared/ui/rl.sliver_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      overlayStyle: getSystemOverlayStyle,
      transitionBackgroundColor: Color(0xff121212),
      body: Builder(
        builder: (context) {
          return Material(
            child: CustomScrollView(
              slivers: [
                AiSliverHeader(
                  titleText: LocaleKeys.settings_title.tr(),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
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
                          print(state);
                          return _buildSettingButton(
                            asset: state.biometricType == BiometricType.face
                                ? AppAssets.faceid
                                : AppAssets
                                    .touchid, // Assuming you have a touchid asset
                            title: "${authCubit.biometricTitle} Access",
                            subtitle: state.isEnabled
                                ? LocaleKeys.common_on.tr()
                                : LocaleKeys.common_off.tr(),
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
                              activeColor: context.theme.colorScheme.primary,
                              onChanged: (bool value) async {
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
                      Gap(12),
                      _buildSettingButton(
                        icon: Icons.language,
                        title: LocaleKeys.settings_language.tr(),
                        onTap: () {
                          context.pushNamed(ScreenNames.language);
                        },
                      ),
                      Gap(12),
                      _buildSettingButton(
                        icon: CupertinoIcons.bell,
                        title: LocaleKeys.settings_notifications.tr(),
                        onTap: () {
                          // Handle Notifications settings
                        },
                      ),
                      Gap(32),
                      _buildSettingButton(
                        asset: AppAssets.person2Wave2,
                        title: LocaleKeys.settings_shareWithFriends.tr(),
                        trailing: SizedBox(),
                        onTap: () {
                          ShareService.instance.shareText(appStoreLink);
                        },
                      ),
                      Gap(12),
                      _buildSettingButton(
                        icon: CupertinoIcons.star,
                        title: LocaleKeys.settings_rateUs.tr(),
                        onTap: () {
                          launchUrl(Uri.parse(appStoreLink));
                        },
                      ),
                      Gap(32),
                      _buildSettingButton(
                        icon: CupertinoIcons.checkmark_shield,
                        title: LocaleKeys.settings_privacyPolicy.tr(),
                        onTap: () async {
                          await showWebViewModal(
                            context: context,
                            url: privacyPolicyUrl,
                            title: LocaleKeys.settings_privacyPolicy.tr(),
                          );
                        },
                      ),
                      Gap(12),
                      _buildSettingButton(
                        asset: AppAssets.terms,
                        title: LocaleKeys.settings_termsOfUse.tr(),
                        onTap: () async {
                          await showWebViewModal(
                            context: context,
                            url: termsOfUseUrl,
                            title: LocaleKeys.settings_termsOfUse.tr(),
                          );
                        },
                      ),
                      Gap(12),
                      _buildSettingButton(
                        asset: AppAssets.info,
                        title: LocaleKeys.settings_aboutApp.tr(),
                        trailing: SizedBox(),
                        onTap: () async {
                          await showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => Consumer<DeviceInfoService>(
                              builder: (context, deviceInfo, child) {
                                return CupertinoAlertDialog(
                                  title:
                                      Text(LocaleKeys.settings_aboutApp.tr()),
                                  content: Column(
                                    children: [
                                      Gap(12),
                                      Text("${deviceInfo.appName}"),
                                      Text(
                                          "${deviceInfo.appVersion} (${deviceInfo.buildNumber})"),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      ReportBugButton(),
                      Gap(12),
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

  Widget _buildSettingButton({
    AppAsset? asset,
    IconData? icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return BouncingButton(
      onPressed: (_) => onTap(),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(24),
        ),
        height: 54,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: asset != null
                    ? AppAssetImage(asset,
                        color: Colors.white,
                        width: 30,
                        height: 24,
                        fit: BoxFit.contain)
                    : icon != null
                        ? Icon(icon, color: Colors.white, size: 24)
                        : null,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    CupertinoIcons.chevron_forward,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
