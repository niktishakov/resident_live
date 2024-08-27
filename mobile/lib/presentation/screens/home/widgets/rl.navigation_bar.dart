import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/extensions/context.extension.dart';

import '../../../navigation/screen_names.dart';

class RlNavBar extends StatelessWidget {
  const RlNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      border: null,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
      automaticallyImplyLeading: false,
      stretch: true,
      largeTitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Resident Live",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                  color: context.theme.colorScheme.secondary)),
        ],
      ),
    );
  }
}

class RlCupertinoNavBar extends StatelessWidget {
  const RlCupertinoNavBar({
    super.key,
    this.title = '',
    this.leading,
  });
  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      leading: leading ??
          BackButton(
            style: ButtonStyle(
              iconSize: MaterialStateProperty.all(20),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
          ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      middle: Text(title, style: context.theme.textTheme.titleMedium),
      border: null,
    );
  }
}
