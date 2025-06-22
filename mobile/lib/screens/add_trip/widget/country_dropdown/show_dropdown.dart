import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/onboarding/pages/find_countries/find_countries_page.dart";
import "package:resident_live/shared/shared.dart";

Future<CountryCode?> showCountryDropdown(BuildContext context) {
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

  @override
  void dispose() {
    sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final countries = codes.toList();

    return DraggableScrollableSheet(
      controller: sheetController,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
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
                    onChanged: (value) {},
                    controller: TextEditingController(),
                  ),
                  ListView.separated(
                    padding: const EdgeInsets.only(top: 32),
                    controller: scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(color: theme.borderPrimary.withValues(alpha: 0.1), height: 1),
                    ),
                    itemBuilder: (context, index) {
                      final country = CountryCode.fromCountryCode(countries[index]["code"] ?? "");
                      final name = country.localize(context).name ?? "";
                      return BouncingButton(
                        onPressed: () => context.pop(countries[index]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                          child: Text(
                            name,
                            style: theme.body16M.copyWith(color: theme.textPrimary),
                          ),
                        ),
                      );
                    },
                    itemCount: countries.length,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
