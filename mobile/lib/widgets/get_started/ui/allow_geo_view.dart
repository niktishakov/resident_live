import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/features/countries/model/countries_cubit.dart';
import 'package:resident_live/features/features.dart';
import 'package:resident_live/features/location/model/location_cubit.dart';
import 'package:resident_live/screens/screens.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllowGeoView extends StatelessWidget {
  const AllowGeoView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGradient = [context.theme.primaryColor, Color(0xff306D99)];
    final successGradient = kSuccessGradient.colors;
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        find<CountriesCubit>(context).syncCountriesByGeo(state.placemark);
      },
      child: BlocBuilder<GetStartedCubit, GetStartedState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: state.focusedCountryIndex == -1
                ? SizedBox(
                    key: const ValueKey<bool>(false),
                    child: SizedBox(),
                  )
                : Column(
                    key: const ValueKey<bool>(true),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text.rich(
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            height: 30 / 24,
                            fontWeight: FontWeight.w600,
                          ),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Allow geolocation   ',
                              ),
                              WidgetSpan(
                                child: Icon(
                                  CupertinoIcons.map_pin_ellipse,
                                  size: 30,
                                  color: context.theme.colorScheme.secondary,
                                ),
                              ),
                              TextSpan(
                                text: '\ntracking to make the\napp work ',
                              ),
                              TextSpan(
                                text: 'automatically',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  height: 30 / 24,
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryButton(
                            animationDuration: 500.ms,
                            onPressed: () => context
                                .read<GetStartedCubit>()
                                .requestGeoPermission(),
                            gradient: LinearGradient(
                              colors: state.isGeoPermissionAllowed
                                  ? successGradient
                                  : primaryGradient,
                            ),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 18,
                              height: 30 / 18,
                              fontWeight: FontWeight.w600,
                            ),
                            trailing: state.isGeoPermissionAllowed
                                ? Icon(CupertinoIcons.checkmark_seal_fill,
                                    size: 22)
                                : null,
                            label: state.isGeoPermissionAllowed
                                ? "Allowed"
                                : "Allow",
                          ).animate(onComplete: (controller) {
                            if (state.isGeoPermissionAllowed) {
                              controller.stop();
                            } else {
                              controller.reset();
                              controller.forward();
                            }
                          }).shimmer(duration: 1.seconds, delay: 1.seconds),
                        ],
                      ),
                      Gap(8),
                    ],
                  ).animate().fade(duration: 500.ms),
          );
        },
      ),
    );
  }
}
