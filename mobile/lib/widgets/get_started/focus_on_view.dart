import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/shared/shared.dart';

class FocusOnView extends StatelessWidget {
  const FocusOnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          style: GoogleFonts.poppins(
            fontSize: 24,
            height: 24 / 30,
            fontWeight: FontWeight.w600,
          ),
          TextSpan(
            children: [
              TextSpan(
                text: 'Focus on one country to\n',
              ),
              TextSpan(
                text: 'effectively',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  height: 30 / 24,
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.primary,
                ),
              ),
              TextSpan(
                text: ' track tax\nresidency',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
