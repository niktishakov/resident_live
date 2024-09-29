import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:resident_live/core/assets/export.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/widgets/progress_bar.dart';

class GreetingView extends StatefulWidget {
  @override
  _GreetingViewState createState() => _GreetingViewState();
}

class _GreetingViewState extends State<GreetingView> {
  String greeting = '';
  RlAsset icon = RlAssets.sunHorizonFill;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _updateGreeting(); // Initial call
    _startTimer(); // Periodically check the time
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(minutes: 1), (t) => _updateGreeting());
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      setState(() {
        greeting = 'Good Morning';
        icon = RlAssets.sunHorizonFill;
      });
    } else if (hour >= 12 && hour < 17) {
      setState(() {
        greeting = 'Good Afternoon';
        icon = RlAssets.sunMaxFill;
      });
    } else if (hour >= 17 && hour < 20) {
      setState(() {
        greeting = 'Good Evening';
        icon = RlAssets.sunHorizonFill;
      });
    } else {
      setState(() {
        greeting = 'Good Night';
        icon = RlAssets.moonFill;
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
                  text: 'Good',
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
                                .withOpacity(0.05),
                            blurRadius: 13,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: RlAssetImage(
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
            greeting.split(' ')[1], // "Morning", "Afternoon", etc.
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 30 / 24,
              color: context.theme.colorScheme.secondary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: GreetingView()));
