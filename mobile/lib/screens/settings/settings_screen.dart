import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:resident_live/features/features.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/shared/ui/rl.sliver_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      overlayStyle: getSystemOverlayStyle,
      transitionBackgroundColor: Color(0xff121212),
      body: CustomScrollView(
        slivers: [
          AiSliverHeader(
            titleText: "Settings",
            // leading: context.canPop() ? AiBackButton() : SizedBox(),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is BiometricAuthenticationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    print(state);
                    final bool isEnabled =
                        (state is BiometricAuthChecked && state.isEnabled) ||
                            state is BiometricAuthenticationComplete;
                    return _buildSettingButton(
                      asset: AppAssets.faceid,
                      title: "Face ID Access",
                      subtitle: isEnabled ? "On" : "Off",
                      onTap: () async {
                        final authCubit = context.read<AuthCubit>();
                        if (isEnabled) {
                          await authCubit.toggleBiometricAuth();
                        } else {
                          await authCubit.authenticateAndToggle();
                        }
                      },
                    );
                  },
                ),
                Gap(12),
                _buildSettingButton(
                  icon: Icons.language,
                  title: "Language",
                  onTap: () {
                    // Handle Language settings
                  },
                ),
                Gap(12),
                _buildSettingButton(
                  icon: CupertinoIcons.bell,
                  title: "Notifications",
                  onTap: () {
                    // Handle Notifications settings
                  },
                ),
                Gap(52),
                _buildSettingButton(
                  asset: AppAssets.person2Wave2,
                  title: "Share with friends",
                  onTap: () {
                    // Handle Share with friends
                  },
                ),
                Gap(12),
                _buildSettingButton(
                  icon: CupertinoIcons.star,
                  title: "Rate Us",
                  onTap: () {
                    // Handle Rate Us
                  },
                ),
                Gap(52),
                _buildSettingButton(
                  icon: CupertinoIcons.checkmark_shield,
                  title: "Privacy Policy",
                  onTap: () {
                    // Handle Rate Us
                  },
                ),
                Gap(12),
                _buildSettingButton(
                  asset: AppAssets.terms,
                  title: "Terms of Use",
                  onTap: () {
                    // Handle Rate Us
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton({
    AppAsset? asset,
    IconData? icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(24),
      ),
      height: 54,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
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
              Icon(CupertinoIcons.chevron_forward,
                  color: Colors.white.withOpacity(0.5), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
