// ignore_for_file: use_build_context_synchronously

import "dart:async";

import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:go_router/go_router.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:resident_live/screens/settings/widgets/report_bug_button.dart";
import "package:resident_live/screens/splash/presplash_screen.dart";
import "package:resident_live/shared/shared.dart";

void showDebugActionsSheet(BuildContext context) {
  Widget buildActionRow({
    required VoidCallback onTap,
    required String title,
    Color color = Colors.purple,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SizedBox(
        height: 44,
        child: BouncingButton(
          onPressed: (_) => onTap(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    elevation: 0,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    routeSettings: const RouteSettings(name: "prompt_examples"),
    builder: (context) {
      return MakeDismissible(
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          shouldCloseOnMinExtent: true,
          builder: (context, controller) => ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: FractionallySizedBox(
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: ListView(
                  controller: controller,
                  children: [
                    const Grabber(color: Colors.white),
                    const Gap(16),
                    const ReportBugButton(),
                    buildActionRow(
                      title: "Erase Data & Restart",
                      color: Colors.red,
                      onTap: () {
                        HydratedBloc.storage.clear();
                      },
                    ),
                    buildActionRow(
                      title: "Go to /pre-splash",
                      color: Colors.blue,
                      onTap: () async {
                        context.pop();
                        unawaited(
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (c) => const PresplashScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    ...ScreenNames.all.map(
                      (e) => buildActionRow(
                        title: "Go to $e",
                        color: Colors.blue,
                        onTap: () {
                          context.pop();
                          context.pushReplacementNamed(e);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
