import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/screen_names.dart';

class RlNavBar extends StatelessWidget {
  const RlNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      // border: Border.all(color: Colors.transparent),
      // backgroundColor: Colors.redAccent,
      padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
      automaticallyImplyLeading: false,
      stretch: true,
      trailing: CupertinoButton(
        onPressed: () {
          context.pushNamed(ScreenNames.addResidency);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.add_circled),
          ],
        ),
      ),
      // middle: Text("Dashboard", style: TextStyle(color: Colors.white)),
      // automaticallyImplyTitle: true,
      largeTitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Dashboard"),
        ],
      ),
    );
  }
}
