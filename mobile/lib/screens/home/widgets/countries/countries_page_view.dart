import "package:auto_size_text/auto_size_text.dart";
import "package:collection/collection.dart";
import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";

import "package:resident_live/app/injection.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/screens/home/cubit/focus_on_country_cubit.dart";
import "package:resident_live/screens/home/widgets/countries/country_card/country_progress_indicator.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/utils/hero_utils.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/shared/widget/rl.outlined_button.dart";

part "country_card/country_card.dart";
part "set_focus/set_focus_button.dart";

class CountriesPageView extends StatefulWidget {
  const CountriesPageView({
    required this.onTap,
    required this.countries,
    required this.focusedCountryCode,
    required this.currentCountryCode,
    super.key,
  });
  final Function(String) onTap;
  final Map<String, List<StayPeriodValueObject>> countries;
  final String focusedCountryCode;
  final String currentCountryCode;
  @override
  State<CountriesPageView> createState() => _CountriesPageViewState();
}

class _CountriesPageViewState extends State<CountriesPageView> {
  late PageController _pageController;
  late List<String> _countries;
  int _currentPage = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePageView();
  }

  void _initializePageView() {
    _countries = widget.countries.keys.toList();

    // Находим индекс focused country, если не найден - используем 0
    final focusedIndex = _countries.indexOf(widget.focusedCountryCode);
    _currentPage = focusedIndex >= 0 ? focusedIndex : 0;

    // Создаем контроллер без анимации
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 1.0);

    _isInitialized = true;
  }

  @override
  void didUpdateWidget(CountriesPageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Если focused country изменился, мгновенно переходим к новой стране
    if (oldWidget.focusedCountryCode != widget.focusedCountryCode ||
        !const DeepCollectionEquality().equals(oldWidget.countries.keys, widget.countries.keys)) {
      _countries = widget.countries.keys.toList();
      final newFocusedIndex = _countries.indexOf(widget.focusedCountryCode);
      final targetPage = newFocusedIndex >= 0 ? newFocusedIndex : 0;

      if (targetPage != _currentPage && _isInitialized) {
        setState(() {
          _currentPage = targetPage;
        });

        // Мгновенный переход без анимации
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(targetPage);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beginBorderRadius = BorderRadius.circular(24);
    debugPrint("countries: ${_countries.length}");

    // Если нет стран, показываем пустой контейнер
    if (_countries.isEmpty) {
      return SizedBox(height: context.mediaQuery.size.height * 0.32);
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Material(
            borderRadius: beginBorderRadius,
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(maxWidth: context.mediaQuery.size.width),
              child: RlCard(
                gradient: kMainGradient,
                borderRadius: beginBorderRadius.topLeft.x,
                padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 8),
                child: SizedBox(
                  height: context.mediaQuery.size.height * 0.32,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _countries.length,
                          physics: _countries.length > 1
                              ? const PageScrollPhysics()
                              : const NeverScrollableScrollPhysics(), // Отключаем скролл если только одна страна
                          itemBuilder: (context, index) {
                            final countryCode = _countries[index];
                            final isHere = countryCode == widget.currentCountryCode;

                            return Hero(
                              tag: "residence_$countryCode",
                              flightShuttleBuilder:
                                  (
                                    flightContext,
                                    animation,
                                    flightDirection,
                                    fromHeroContext,
                                    toHeroContext,
                                  ) => toFirstHeroFlightShuttleBuilder(
                                    flightContext: flightContext,
                                    animation: animation,
                                    flightDirection: flightDirection,
                                    fromHeroContext: fromHeroContext,
                                    toHeroContext: toHeroContext,
                                    beginBorderRadius: beginBorderRadius.topLeft.x,
                                    endBorderRadius: kLargeBorderRadius,
                                  ),
                              child: Material(
                                color: Colors.transparent,
                                child: CountryCard(
                                  countryCode: countryCode,
                                  isHere: isHere,
                                  onTap: widget.onTap,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Gap(8),
                      // Показываем индикаторы только если стран больше одной
                      if (_countries.length > 1)
                        AnimatedDots(
                          value: _currentPage,
                          maxValue: _countries.length,
                          radius: 3,
                          padding: 3,
                          activeColor: context.theme.primaryColor,
                          inactiveColor: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
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
}
