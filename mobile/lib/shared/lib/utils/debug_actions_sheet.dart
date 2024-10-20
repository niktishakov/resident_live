// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:resident_live/features/features.dart';
import 'package:resident_live/shared/shared.dart';

import '../../../app/navigation/screen_names.dart';
import '../../../screens/screens.dart';

void showDebugActionsSheet(BuildContext context) {
  Widget buildActionRow({onTap, title, color = Colors.purple}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SizedBox(
        height: 44,
        child: BouncingButton(
          onPressed: (_) => onTap(),
          child: Container(
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
                color: Theme.of(context).colorScheme.background,
                child: FractionallySizedBox(
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  child: ListView(
                    controller: controller,
                    children: [
                      Grabber(color: Colors.white),
                      const Gap(16),
                      buildActionRow(
                        title: "Erase Data & Restart",
                        color: Colors.red,
                        onTap: () {
                          find<LocationCubit>(context).reset();
                          find<CountriesCubit>(context).reset();
                          find<UserCubit>(context).reset();
                          HydratedBloc.storage.clear();
                        },
                      ),
                      buildActionRow(
                        title: "Go to /pre-splash",
                        color: Colors.blue,
                        onTap: () async {
                          context.pop();
                          unawaited(Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (c) => PresplashScreen(),
                            ),
                          ));
                        },
                      ),
                      ...ScreenNames.all
                          .map((e) => buildActionRow(
                                title: "Go to $e",
                                color: Colors.blue,
                                onTap: () {
                                  context.pop();
                                  context.pushReplacementNamed(e);
                                },
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
