import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/shared/shared.dart';

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
    this.actions,
  });
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
    return CupertinoNavigationBar(
      padding: EdgeInsetsDirectional.only(start: 0, end: 0),
      leading: canPop
          ? leading ??
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: context.pop,
                  child: Icon(
                    CupertinoIcons.back,
                    size: 28,
                    color: context.theme.colorScheme.secondary,
                  ))
          : null,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      middle: Text(title, style: context.theme.textTheme.titleMedium),
      border: null,
      trailing: actions != null
          ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
          : null,
    );
  }
}
