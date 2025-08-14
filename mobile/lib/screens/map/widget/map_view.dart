import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/screens/map/widget/stay_period_list/stay_period_list.dart";
import "package:resident_live/shared/lib/plugin/apple_maps_3d.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/shared.dart";

class MapView extends StatefulWidget {
  const MapView({required this.stayPeriods, super.key});

  final List<StayPeriodValueObject> stayPeriods;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final List<StayPeriodValueObject> _relevantPeriods;
  late final List<String> _uniqueCountryCodes;
  late final CountryBackgroundCubit _countryBgCubit;
  final GlobalKey<AppleGlobeViewState> _globeKey = GlobalKey();
  final _sheetController = DraggableScrollableController();
  int? _selectedPeriodIndex;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final twelveMonthsAgo = now.subtract(const Duration(days: 365));

    _relevantPeriods =
        widget.stayPeriods.where((period) => period.endDate.isAfter(twelveMonthsAgo)).toList()
          ..sort((a, b) => b.endDate.compareTo(a.endDate));

    _uniqueCountryCodes = _relevantPeriods.map((period) => period.countryCode).toSet().toList();

    _countryBgCubit = getIt<CountryBackgroundCubit>()
      ..preloadCountryBackgrounds(_uniqueCountryCodes);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _globeKey.currentState?.setOnCountrySelectedCallback(_onCountrySelectedFromMap);

      Future.delayed(const Duration(milliseconds: 1000), () {
        _sheetController.animateTo(
          0.45,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      });
    });
  }

  void _onCountrySelectedFromMap(String countryCode) {
    debugPrint("[TouchDebug] Country selected from map: $countryCode");
    final index = _relevantPeriods.indexWhere((period) => period.countryCode == countryCode);

    if (index != -1) {
      debugPrint("[TouchDebug] Found period at index: $index");
      VibrationService.instance.tap();
      setState(() {
        _selectedPeriodIndex = index;
      });

      _globeKey.currentState?.selectCountry(countryCode);

      Future.delayed(const Duration(milliseconds: 300), () {
        _sheetController.animateTo(
          0.45,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      debugPrint("[TouchDebug] Country not found in relevant periods: $countryCode");
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _countryBgCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    if (_relevantPeriods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text("Нет данных о путешествиях"),
      );
    }

    return BlocProvider.value(
      value: _countryBgCubit,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: context.mediaQuery.size.height * 0.2,
            child: AppleGlobeView(
              key: _globeKey,
              countryCodes: _uniqueCountryCodes,
              stayPeriods: widget.stayPeriods,
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.8,

            shouldCloseOnMinExtent: false,
            controller: _sheetController,
            builder: (context, scrollController) {
              return Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          BouncingButton(
                            onPressed: () => context.pop(),
                            vibrate: false,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.bgModal.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(CupertinoIcons.chevron_left),
                              ),
                            ),
                          ),
                          const Spacer(),
                          BouncingButton(
                            onPressed: () {
                              VibrationService.instance.tap();
                              _globeKey.currentState?.centerOnCurrentLocation();
                              _sheetController.animateTo(
                                0.45,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.bgModal.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(CupertinoIcons.location),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.bgModal,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Grabber(),
                              const SizedBox(height: 16),
                              Text(
                                "Your journey for\nthe last 12 months",
                                textAlign: TextAlign.center,
                                style: theme.title20Semi.copyWith(fontWeight: FontWeight.w600),
                              ),
                              context.vBox24,
                              StayPeriodList(
                                sheetController: scrollController,
                                stayPeriods: _relevantPeriods,
                                selectedPeriodIndex: _selectedPeriodIndex,
                                onPeriodTap: (countryCode, index) {
                                  VibrationService.instance.tap();
                                  setState(() {
                                    _selectedPeriodIndex = index;
                                  });

                                  _globeKey.currentState?.selectCountry(countryCode);

                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    _sheetController.animateTo(
                                      0.25,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                },
                              ),

                              SizedBox(height: context.mediaQuery.viewPadding.bottom),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
