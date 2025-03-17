import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/features/countries/model/countries_cubit.dart';
import 'package:resident_live/screens/screens.dart';
import 'package:resident_live/shared/shared.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetStartedCubit, GetStartedState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
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
          child: !state.isGeoPermissionAllowed
              ? SizedBox(key: const ValueKey<bool>(false))
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
                              text:
                                  'No server-side data\nstorage. Everything\nworks ',
                            ),
                            TextSpan(
                              text: 'offline',
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryButton(
                          label: 'Get Started',
                          gradient: LinearGradient(colors: [
                            context.theme.primaryColor,
                            Color(0xff306D99),
                          ],),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 18,
                            height: 30 / 18,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () {
                            final countries = find<CountriesCubit>(context)
                                .state
                                .countries
                                .values
                                .toList();
                            final index = find<GetStartedCubit>(context)
                                .state
                                .focusedCountryIndex;

                            find<CountriesCubit>(context)
                                .setFocusedCountry(countries[index]);
                            find<OnboardingCubit>(context).reset();

                            context.goNamed(ScreenNames.home);
                          },
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .shimmer(duration: 1.seconds, delay: 1.seconds),
                      ],
                    ),
                  ],
                ).animate().fade(duration: 500.ms),
        );
      },
    );
  }
}
