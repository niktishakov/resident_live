import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:resident_live/screens/onboarding/pages/find_countries/find_countries_page.dart";
import "package:resident_live/shared/shared.dart";

Future<CountryCode?> showCountryModal(BuildContext context) {
  return showModalBottomSheet<CountryCode?>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: true,
    useRootNavigator: true,
    builder: (context) => const _Content(),
  );
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  final sheetController = DraggableScrollableController();
  final searchController = TextEditingController();
  String searchQuery = "";
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (searchController.text.isEmpty && searchQuery.isNotEmpty) {
        setState(() {
          searchQuery = "";
        });
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    sheetController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _closeModal([dynamic result]) {
    if (_isDisposed || !mounted) return;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final allCountries = codes.toList();

    final filteredCountries = searchQuery.isEmpty
        ? allCountries
        : allCountries.where((country) {
            final countryCode = CountryCode.fromCountryCode(country["code"] ?? "");
            final name = countryCode.localize(context).toCountryStringOnly();
            return name.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _closeModal, // Close without result
      child: DraggableScrollableSheet(
        controller: sheetController,
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return GestureDetector(
            onTap: () {}, // Prevent tap from bubbling up
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: RlCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    const Grabber(),
                    context.vBox16,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Country",
                        style: theme.title20Semi.copyWith(color: theme.textPrimary),
                      ),
                    ),
                    context.vBox16,
                    SearchField(
                      onTap: () =>
                          sheetController.animateTo(0.8, duration: 300.ms, curve: Curves.easeInOut),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      controller: searchController,
                    ),
                    Expanded(
                      child: FadeBorder(
                        stops: const [0, 0.001],
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 16),
                          controller: scrollController,
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              color: theme.borderPrimary.withValues(alpha: 0.1),
                              height: 1,
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final country = CountryCode.fromCountryCode(
                              filteredCountries[index]["code"] ?? "",
                            );
                            final name = country.localize(context).toCountryStringOnly();
                            return BouncingButton(
                              onPressed: () {
                                // Convert Map to CountryCode and close modal
                                final selectedCountry = CountryCode.fromCountryCode(
                                  filteredCountries[index]["code"] ?? "",
                                );
                                _closeModal(selectedCountry);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                child: Text(
                                  name,
                                  style: theme.body16M.copyWith(color: theme.textPrimary),
                                ),
                              ),
                            );
                          },
                          itemCount: filteredCountries.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
