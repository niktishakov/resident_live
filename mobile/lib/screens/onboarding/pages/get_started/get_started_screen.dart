import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:resident_live/screens/onboarding/pages/get_started/cubit/get_started_cubit.dart";
import "package:resident_live/screens/onboarding/pages/get_started/widget/allow_geo_view.dart";
import "package:resident_live/screens/onboarding/pages/get_started/widget/focus_on_view.dart";
import "package:resident_live/screens/onboarding/pages/get_started/widget/get_started_view.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/shared.dart";

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

        if (state.focusedCountryError.isNotEmpty) {
          ToastService.instance.showToast(
            context,
            message: state.focusedCountryError,
            status: ToastStatus.failure,
          );
        }

        if (state.getPlacemarkError.isNotEmpty) {
          ToastService.instance.showToast(
            context,
            message: state.getPlacemarkError,
            status: ToastStatus.failure,
          );
        }
      },
      child: Scaffold(
        body: FadeBorder(
          stops: const [0, 0.1],
          child: SizedBox(
            height: context.mediaQuery.size.height,
            child: ListView(
              controller: _controller,
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: context.mediaQuery.padding.top,
              ),
              children: [
                const Gap(32),
                const FocusOnView(),
                const Gap(32),
                const AllowGeoView(),
                const Gap(32),
                const GetStartedView(),
                Gap(context.mediaQuery.padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
