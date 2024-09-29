import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/presentation/navigation/router.dart';
import 'package:resident_live/presentation/widgets/rl.sliver_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AiSliverHeader(
            titleText: "Settings",
            // leading: context.canPop() ? AiBackButton() : SizedBox(),
          ),
        ],
      ),
    );
  }
}
