import "dart:async";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/shared/shared.dart";

class GreetingView extends StatefulWidget {
  const GreetingView({super.key});

  @override
  GreetingViewState createState() => GreetingViewState();
}

class GreetingViewState extends State<GreetingView> {
  String greeting = "";
  AppAsset icon = AppAssets.sunHorizonFill;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer(); // Periodically check the time
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateGreeting(); // Move initial call here
  }

  void _startTimer() {
    timer =
        Timer.periodic(const Duration(minutes: 1), (t) => _updateGreeting());
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      setState(() {
        greeting = S.of(context).homeGoodMorning;
        icon = AppAssets.sunHorizonFill;
      });
    } else if (hour >= 12 && hour < 17) {
      setState(() {
        greeting = S.of(context).homeGoodAfternoon;
        icon = AppAssets.sunMaxFill;
      });
    } else if (hour >= 17 && hour < 20) {
      setState(() {
        greeting = S.of(context).homeGoodEvening;
        icon = AppAssets.sunHorizonFill;
      });
    } else {
      setState(() {
        greeting = S.of(context).homeGoodNight;
        icon = AppAssets.moonFill;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 30 / 24,
                color: context.theme.colorScheme.secondary,
              ),
              children: [
                TextSpan(
                  text: greeting.split(" ")[0],
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.theme.colorScheme.secondary
                                .withValues(alpha: 0.05),
                            blurRadius: 13,
                            offset: const Offset(
                              0,
                              1,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: AppAssetImage(
                        icon,
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            greeting.split(" ")[1], // "Morning", "Afternoon", etc.
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 30 / 24,
              color: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: GreetingView()));
