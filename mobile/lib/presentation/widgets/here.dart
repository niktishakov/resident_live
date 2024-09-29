import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/core/extensions/context.extension.dart';

class Here extends StatelessWidget {
  const Here({super.key, this.shorter = false});
  final bool shorter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      // color: Colors.amber,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (!shorter)
                Text(
                  "Here",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.theme.colorScheme.secondary.withOpacity(0.5),
                    height: 14 / 12,
                  ),
                ),
              SizedBox(width: 4),
              Icon(
                CupertinoIcons.circle_filled,
                color: Color(0xff90FFA2),
                size: 14,
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .then()
                  .fadeOut(duration: 300.ms, delay: 1000.ms),
            ],
          ),
        ],
      ),
    );
  }
}
