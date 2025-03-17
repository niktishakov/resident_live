import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/screens/screens.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/widgets/widgets.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetStartedCubit, GetStartedState>(
      listener: (context, state) {
        if (state.isGeoPermissionAllowed || state.focusedCountryIndex != -1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(
              50.ms,
              () => _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: 300.ms,
                curve: Curves.fastOutSlowIn,
              ),
            );
          });
        }
      },
      child: Scaffold(
        body: FadeBorder(
          stops: [0, 0.1],
          child: Container(
            height: context.mediaQuery.size.height,
            child: ListView(
              controller: _controller,
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: context.mediaQuery.padding.top,
              ),
              children: [
                Gap(32),
                FocusOnView(),
                Gap(32),
                AllowGeoView(),
                Gap(32),
                GetStartedView(),
                Gap(context.mediaQuery.padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
