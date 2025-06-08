import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/shared/lib/assets/app.asset.dart";
import "package:resident_live/shared/lib/assets/app.asset_image.dart";
import "package:resident_live/shared/widget/bouncing_button.dart";

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    required this.title,
    required this.onTap,
    super.key,
    this.asset,
    this.icon,
    this.subtitle,
    this.trailing,
  });

  final AppAsset? asset;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onPressed: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(24),
        ),
        height: 54,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child:
                    asset != null
                        ? AppAssetImage(
                          asset!,
                          color: Colors.white,
                          width: 30,
                          height: 24,
                          fit: BoxFit.contain,
                        )
                        : icon != null
                        ? Icon(icon, color: Colors.white, size: 24)
                        : null,
              ),
              const SizedBox(width: 16),
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
                        subtitle!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    CupertinoIcons.chevron_forward,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 20,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
