import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import '../../navigation/screen_names.dart';

part 'bottom_bar.dart';

class BottomBarScaffold extends StatelessWidget {
  const BottomBarScaffold({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: AiBottomBar(
        state: state,
      ),
    );
  }
}
